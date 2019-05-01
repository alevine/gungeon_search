defmodule GungeonSearch.Item do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  import GungeonSearch.Utils

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
  Fuzzy searches based on the given `query_string` up to the given `threshold`

  Returns `[results]`
  """
  def fuzzy_search(query_string, threshold \\ 3) do
    query_string = query_string |> String.downcase()

    query =
      from item in GungeonSearch.Item,
        where:
          levenshtein(item.name, ^query_string, ^threshold) or
          levenshtein(item.quote, ^query_string, ^threshold),
        order_by:
          fragment(
            "LEAST (?, ?)",
            levenshtein(item.name, ^query_string),
            levenshtein(item.quote, ^query_string)
          )

    GungeonSearch.Repo.all(query)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :image, :type, :quote, :quality, :effect, :link])
    |> validate_required([:name, :image, :type, :quote, :quality, :effect, :link])
  end
end
