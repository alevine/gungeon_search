defmodule GungeonSearch.ItemSynergy do
  @moduledoc """
  Join row between an `Item` and a `Synergy`, carrying the effect text as
  described from that item's point of view.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_synergies" do
    field :effect, :string

    belongs_to :item, GungeonSearch.Item
    belongs_to :synergy, GungeonSearch.Synergy

    timestamps()
  end

  @doc false
  def changeset(item_synergy, attrs) do
    item_synergy
    |> cast(attrs, [:effect, :item_id, :synergy_id])
    |> validate_required([:item_id, :synergy_id])
    |> unique_constraint([:item_id, :synergy_id])
  end
end
