defmodule GungeonSearch.Repo.Migrations.ChangeNotesColumnType do
  use Ecto.Migration

  def change do
    alter table(:guns) do
      modify :notes, :text
    end
  end
end
