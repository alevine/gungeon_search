defmodule GungeonSearch.Repo.Migrations.CreateSynergies do
  use Ecto.Migration

  def change do
    create table(:synergies) do
      add :name, :string, null: false
      add :link, :string, null: false

      timestamps()
    end

    create unique_index(:synergies, [:link])
  end
end
