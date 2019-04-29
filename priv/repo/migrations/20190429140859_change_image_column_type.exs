defmodule GungeonSearch.Repo.Migrations.ChangeImageColumnType do
  use Ecto.Migration

  def change do
    alter table(:guns) do
      modify :image, :text
    end
  end
end
