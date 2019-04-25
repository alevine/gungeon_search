defmodule GungeonSearch.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :image, :string
      add :type, :string
      add :quote, :string
      add :quality, {:array, :string}
      add :effect, :string
      add :link, :string

      timestamps()
    end

  end
end
