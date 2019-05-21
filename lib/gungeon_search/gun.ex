defmodule GungeonSearch.Gun do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @derive [Poison.Encoder]

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
    field :synergies, {:array, {:map, :string}}

    timestamps()
  end

  @doc """
  Searches for a gun based on the given `query_string`

  Returns `[results]`
  """
  def search(query_string) do
    query_string = query_string |> String.downcase()
    query_string = "%" <> query_string <> "%"

    query =
      from gun in GungeonSearch.Gun,
        where: ilike(gun.name, ^query_string) or ilike(gun.quote, ^query_string)

    GungeonSearch.Repo.all(query)
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
    |> validate_required([:name, :image, :type, :quote, :quality, :link, :notes])
  end
end
