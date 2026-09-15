defmodule GungeonSearch.Repo.Migrations.DropEmbeddedSynergiesColumns do
  use Ecto.Migration

  def up do
    alter table(:guns) do
      remove :synergies
    end

    alter table(:items) do
      remove :synergies
    end
  end

  def down do
    alter table(:guns) do
      add :synergies, {:array, {:map, :string}}
    end

    alter table(:items) do
      add :synergies, {:array, {:map, :string}}
    end
  end
end
