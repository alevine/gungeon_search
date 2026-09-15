defmodule GungeonSearch.Synergy do
  @moduledoc """
  A named synergy from the wiki's Synergies page (e.g. "Great Queen Ant").
  Shared across every gun/item that participates in it - see `GunSynergy`
  and `ItemSynergy` for the per-participant effect text.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "synergies" do
    field :name, :string
    field :link, :string

    timestamps()
  end

  @doc false
  def changeset(synergy, attrs) do
    synergy
    |> cast(attrs, [:name, :link])
    |> validate_required([:name, :link])
    |> unique_constraint(:link)
  end
end
