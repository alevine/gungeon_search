defmodule GungeonSearch.GunSynergy do
  @moduledoc """
  Join row between a `Gun` and a `Synergy`, carrying the effect text as
  described from that gun's point of view.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "gun_synergies" do
    field :effect, :string

    belongs_to :gun, GungeonSearch.Gun
    belongs_to :synergy, GungeonSearch.Synergy

    timestamps()
  end

  @doc false
  def changeset(gun_synergy, attrs) do
    gun_synergy
    |> cast(attrs, [:effect, :gun_id, :synergy_id])
    |> validate_required([:gun_id, :synergy_id])
    |> unique_constraint([:gun_id, :synergy_id])
  end
end
