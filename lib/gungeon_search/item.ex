defmodule GungeonSearch.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @derive [Poison.Encoder]

  schema "items" do
    field :effect, :string
    field :image, :string
    field :link, :string
    field :name, :string
    field :quality, {:array, :string}
    field :quote, :string
    field :type, :string

    timestamps()
  end

  @doc """
  Searches for an item based on the given `query_string`

  Returns `[results]`
  """
  def search(query_string) do
    query_string = query_string |> String.downcase()
    query_string = "%" <> query_string <> "%"

    query =
      from item in GungeonSearch.Item,
        where: ilike(item.name, ^query_string) or ilike(item.quote, ^query_string)

    GungeonSearch.Repo.all(query)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :image, :type, :quote, :quality, :effect, :link])
    |> validate_required([:name, :image, :type, :quote, :quality, :effect, :link])
  end
end
