defmodule GungeonSearch.Repo.Migrations.AddUniqueNameQuoteIndexes do
  use Ecto.Migration

  @moduledoc """
  Backs idempotent upserts in `mix gungeon.seed`. Plain `name` isn't unique
  on its own - e.g. items has 5 distinct "Master Round" tiers that only
  differ by `quote` ("First Chamber".."Fifth Chamber") - so the seed task
  upserts on the (name, quote) pair instead.
  """

  def change do
    create unique_index(:guns, [:name, :quote])
    create unique_index(:items, [:name, :quote])
  end
end
