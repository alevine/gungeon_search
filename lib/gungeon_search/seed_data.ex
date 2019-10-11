defmodule GungeonSearch.DatabaseSeeder do
  alias GungeonSearch.Repo
  alias GungeonSearch.Item
  alias GungeonSearch.Gun
  import Ecto.Query

  @item_path "/Users/alevine/Documents/gungeon_search/items-data.json"
  @gun_path "/Users/alevine/Documents/gungeon_search/guns-data.json"
  @item_synergy_path Path.expand("items-synergy-data.json") |> Path.absname
  @guns_synergy_path Path.expand("guns-synergy-data.json") |> Path.absname

  @doc """
    Reads content from a given JSON file path and decodes it with Poison.
  """
  def get_content(path) do
    {:ok, content} = File.read(path)

    content |> Poison.decode!()
  end

  @doc """
    Inserts items/guns into the database. Currently paths to JSON files are
    hardcoded, need to figure out relative paths in Elixir...
  """
  def insert_items do
    Enum.map(get_content(@item_path), fn item ->
      %Item{} |> Item.changeset(item) |> Repo.insert!()
    end)

    Enum.map(get_content(@gun_path), fn item ->
      %Gun{} |> Gun.changeset(item) |> Repo.insert!()
    end)
  end

  @doc """
    Inserts synergies into the database. Should be ran after insert_items.
    Searches for all items and guns based on the name from the synergy JSON
    file, creates a changeset with their respective synergies, and updates
    the entry.
  """
  def insert_synergies do
    Enum.map(get_content(@item_synergy_path), fn synergy ->
      item_name = elem(synergy, 0)

      query = from item in Item, where: like(item.name, ^item_name)
      GungeonSearch.Repo.all(query)
      |> Enum.map(fn item ->
        Ecto.Changeset.change(item, synergies: elem(synergy, 1)) |> Repo.update!()
      end)
    end)

    Enum.map(get_content(@guns_synergy_path), fn synergy ->
      gun_name = elem(synergy, 0)

      query = from gun in Gun, where: like(gun.name, ^gun_name)
      GungeonSearch.Repo.all(query)
      |> Enum.map(fn gun ->
        Ecto.Changeset.change(gun, synergies: elem(synergy, 1)) |> Repo.update!()
      end)
    end)
  end
end
