defmodule GungeonSearch.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "items" do
    field :effect, :string
    field :image, :string
    field :link, :string
    field :name, :string
    field :quality, {:array, :string}
    field :quote, :string
    field :type, :string

    has_many :item_synergies, GungeonSearch.ItemSynergy
    has_many :synergies, through: [:item_synergies, :synergy]

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :image, :type, :quote, :quality, :effect, :link])
  end
end
