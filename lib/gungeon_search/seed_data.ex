defmodule GungeonSearch.DatabaseSeeder do
  alias GungeonSearch.Repo
  alias GungeonSearch.Item
  alias GungeonSearch.Gun

  @item_path "/Users/alevine/Documents/gungeon_search/items-data.json"
  @gun_path "/Users/alevine/Documents/gungeon_search/guns-data.json"

  def get_content(path) do
    {:ok, content} = File.read(path)

    content |> Poison.decode!
  end

  def insert_item do
    Enum.map(get_content(@item_path), fn item -> %Item{} |> Item.changeset(item) |> Repo.insert! end)
    Enum.map(get_content(@gun_path), fn item -> %Gun{} |> Gun.changeset(item) |> Repo.insert! end)
  end
end
