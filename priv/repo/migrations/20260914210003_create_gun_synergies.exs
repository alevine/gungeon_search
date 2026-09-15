defmodule GungeonSearch.Repo.Migrations.CreateGunSynergies do
  use Ecto.Migration

  def change do
    create table(:gun_synergies) do
      add :gun_id, references(:guns, on_delete: :delete_all), null: false
      add :synergy_id, references(:synergies, on_delete: :delete_all), null: false
      # The wiki describes each synergy from the participant's own point of
      # view, so the effect text differs per gun/item even for the same
      # named synergy - it belongs on the join row, not on `synergies`.
      add :effect, :text

      timestamps()
    end

    create unique_index(:gun_synergies, [:gun_id, :synergy_id])
    create index(:gun_synergies, [:synergy_id])
  end
end
