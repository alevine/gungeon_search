defmodule GungeonSearch.Repo.Migrations.CreateGuns do
  use Ecto.Migration

  def change do
    create table(:guns) do
      add :name, :string
      add :image, :string
      add :type, :string
      add :quote, :string
      add :quality, :string
      add :link, :string
      add :magazine_size, :string
      add :ammo_capacity, :string
      add :damage, :string
      add :fire_rate, :string
      add :reload_time, :string
      add :shot_speed, :string
      add :spread, :string
      add :notes, :string

      timestamps()
    end
  end
end
