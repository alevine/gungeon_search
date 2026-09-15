defmodule Mix.Tasks.Gungeon.Seed do
  use Mix.Task

  alias GungeonSearch.{Gun, GunSynergy, Item, ItemSynergy, Repo, Synergy}

  @shortdoc "Loads scraped wiki data from priv/repo/data into the database"
  @moduledoc """
  Loads guns, items, and their synergies from the JSON files produced by
  the Ruby scraper (`priv/repo/data/*.json`) into the database.

  Safe to re-run - guns/items are upserted on (name, quote), synergies on
  their wiki link, and gun/item <-> synergy join rows on the pair.

      mix gungeon.seed
  """

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")

    data_dir = Application.app_dir(:gungeon_search, "priv/repo/data")

    guns = load_json(data_dir, "guns.json")
    items = load_json(data_dir, "items.json")
    gun_synergies_by_name = load_json(data_dir, "guns-synergies.json")
    item_synergies_by_name = load_json(data_dir, "items-synergies.json")

    Mix.shell().info("Seeding #{length(guns)} guns and #{length(items)} items...")
    gun_ids_by_name = upsert_entities(Gun, guns, [:name, :quote])
    item_ids_by_name = upsert_entities(Item, items, [:name, :quote])

    Mix.shell().info("Seeding synergies...")
    seed_synergies(gun_synergies_by_name, gun_ids_by_name, GunSynergy, :gun_id)
    seed_synergies(item_synergies_by_name, item_ids_by_name, ItemSynergy, :item_id)

    Mix.shell().info("Done.")
  end

  defp load_json(dir, filename) do
    dir
    |> Path.join(filename)
    |> File.read!()
    |> Jason.decode!()
  end

  # Upserts each row (a string-keyed map from JSON) into `schema`, keyed on
  # `conflict_target` (a unique index). Returns %{name => [id, ...]} so
  # synergies (keyed only by name in the source data) can be applied to
  # every row sharing that name - e.g. items has 5 distinct "Master Round"
  # tiers that all carry the same synergies.
  defp upsert_entities(schema, rows, conflict_target) do
    fields = schema.__schema__(:fields) -- [:id]
    blank_row = for field <- fields, into: %{}, do: {field, nil}
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    entries =
      Enum.map(rows, fn row ->
        atomized = for {key, value} <- row, into: %{}, do: {String.to_existing_atom(key), value}

        blank_row
        |> Map.merge(atomized)
        |> Map.put(:inserted_at, now)
        |> Map.put(:updated_at, now)
      end)

    Repo.insert_all(schema, entries,
      on_conflict: {:replace_all_except, [:id, :inserted_at]},
      conflict_target: conflict_target
    )

    schema
    |> Repo.all()
    |> Enum.group_by(& &1.name, & &1.id)
  end

  defp seed_synergies(synergies_by_entity_name, ids_by_name, join_schema, fk_field) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    Enum.each(synergies_by_entity_name, fn {entity_name, synergy_rows} ->
      case Map.get(ids_by_name, entity_name) do
        nil ->
          Mix.shell().info("  skipping synergies for unknown entity #{inspect(entity_name)}")

        entity_ids ->
          Enum.each(synergy_rows, fn %{"name" => name, "effect" => effect, "link" => link} ->
            synergy = upsert_synergy(name, link, now)

            Enum.each(entity_ids, fn entity_id ->
              Repo.insert_all(
                join_schema,
                [
                  %{
                    fk_field => entity_id,
                    synergy_id: synergy.id,
                    effect: effect,
                    inserted_at: now,
                    updated_at: now
                  }
                ],
                on_conflict: {:replace, [:effect, :updated_at]},
                conflict_target: [fk_field, :synergy_id]
              )
            end)
          end)
      end
    end)
  end

  defp upsert_synergy(name, link, now) do
    case Repo.get_by(Synergy, link: link) do
      nil -> Repo.insert!(%Synergy{name: name, link: link, inserted_at: now, updated_at: now})
      existing -> existing
    end
  end
end
