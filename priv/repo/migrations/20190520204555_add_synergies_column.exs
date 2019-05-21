defmodule GungeonSearch.Repo.Migrations.AddSynergiesColumn do
  use Ecto.Migration

  def change do
    alter table(:guns) do
      add :synergies, {:array, {:map, :string}}
    end

    alter table(:items) do
      add :synergies, {:array, {:map, :string}}
    end
  end
end
