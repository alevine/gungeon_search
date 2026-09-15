defmodule GungeonSearch.Repo.Migrations.CreateItemSynergies do
  use Ecto.Migration

  def change do
    create table(:item_synergies) do
      add :item_id, references(:items, on_delete: :delete_all), null: false
      add :synergy_id, references(:synergies, on_delete: :delete_all), null: false
      add :effect, :text

      timestamps()
    end

    create unique_index(:item_synergies, [:item_id, :synergy_id])
    create index(:item_synergies, [:synergy_id])
  end
end
