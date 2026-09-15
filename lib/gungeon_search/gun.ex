defmodule GungeonSearch.Gun do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "guns" do
    field :ammo_capacity, :string
    field :damage, :string
    field :fire_rate, :string
    field :image, :string
    field :link, :string
    field :magazine_size, :string
    field :name, :string
    field :notes, :string
    field :quality, :string
    field :quote, :string
    field :reload_time, :string
    field :shot_speed, :string
    field :spread, :string
    field :type, :string

    has_many :gun_synergies, GungeonSearch.GunSynergy
    has_many :synergies, through: [:gun_synergies, :synergy]

    timestamps()
  end

  @doc false
  def changeset(gun, attrs) do
    gun
    |> cast(attrs, [
      :name,
      :image,
      :type,
      :quote,
      :quality,
      :link,
      :magazine_size,
      :ammo_capacity,
      :damage,
      :fire_rate,
      :reload_time,
      :shot_speed,
      :spread,
      :notes
    ])
  end
end
