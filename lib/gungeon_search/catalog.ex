defmodule GungeonSearch.Catalog do
  @moduledoc """
  The Catalog context - the single entry point for reading guns, items, and
  their synergies. Callers (controllers, LiveViews) should go through this
  module rather than querying `Gun`/`Item` directly.
  """

  import Ecto.Query

  alias GungeonSearch.{Gun, Item, Repo}

  @search_similarity_threshold 0.2
  @default_search_limit 20

  @doc """
  Fuzzy-searches guns and items by name/quote, ranked by trigram
  similarity (via the `pg_trgm` extension - see the
  `add_trigram_search_indexes` migration).

  Returns a single, name-ranked list of lightweight result maps:
  `%{id:, type: :gun | :item, name:, image:, quote:}` - enough to render
  search suggestions without pulling full gun/item rows for every
  keystroke. Fetch the full record afterwards via `get_gun!/1` or
  `get_item!/1`.
  """
  def search(query_string, opts \\ [])

  def search(nil, _opts), do: []

  def search(query_string, opts) do
    case String.trim(query_string) do
      "" ->
        []

      trimmed ->
        limit = Keyword.get(opts, :limit, @default_search_limit)

        combined = union_all(gun_matches(trimmed), ^item_matches(trimmed))

        from(r in subquery(combined), order_by: [desc: r.rank], limit: ^limit)
        |> Repo.all()
    end
  end

  defp gun_matches(term) do
    like = "%#{term}%"

    from g in Gun,
      where:
        ilike(g.name, ^like) or ilike(g.quote, ^like) or
          fragment("similarity(?, ?) > ?", g.name, ^term, @search_similarity_threshold) or
          fragment("similarity(?, ?) > ?", g.quote, ^term, @search_similarity_threshold),
      select: %{
        id: g.id,
        type: "gun",
        name: g.name,
        image: g.image,
        quote: g.quote,
        rank:
          fragment("greatest(similarity(?, ?), similarity(?, ?))", g.name, ^term, g.quote, ^term)
      }
  end

  defp item_matches(term) do
    like = "%#{term}%"

    from i in Item,
      where:
        ilike(i.name, ^like) or ilike(i.quote, ^like) or
          fragment("similarity(?, ?) > ?", i.name, ^term, @search_similarity_threshold) or
          fragment("similarity(?, ?) > ?", i.quote, ^term, @search_similarity_threshold),
      select: %{
        id: i.id,
        type: "item",
        name: i.name,
        image: i.image,
        quote: i.quote,
        rank:
          fragment("greatest(similarity(?, ?), similarity(?, ?))", i.name, ^term, i.quote, ^term)
      }
  end

  @doc "Fetches a gun by id with its synergies preloaded, raising if not found."
  def get_gun!(id) do
    Gun
    |> Repo.get!(id)
    |> Repo.preload(gun_synergies: :synergy)
  end

  @doc "Fetches an item by id with its synergies preloaded, raising if not found."
  def get_item!(id) do
    Item
    |> Repo.get!(id)
    |> Repo.preload(item_synergies: :synergy)
  end

  @doc """
  Normalizes a preloaded gun/item's join rows into a flat list of
  `%{name:, effect:, link:}` maps, sorted by name.
  """
  def synergies_for(%Gun{gun_synergies: gun_synergies}) when is_list(gun_synergies) do
    flatten_synergies(gun_synergies)
  end

  def synergies_for(%Item{item_synergies: item_synergies}) when is_list(item_synergies) do
    flatten_synergies(item_synergies)
  end

  defp flatten_synergies(join_rows) do
    join_rows
    |> Enum.map(fn join_row ->
      %{name: join_row.synergy.name, effect: join_row.effect, link: join_row.synergy.link}
    end)
    |> Enum.sort_by(& &1.name)
  end
end
