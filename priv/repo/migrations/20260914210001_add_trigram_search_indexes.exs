defmodule GungeonSearch.Repo.Migrations.AddTrigramSearchIndexes do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"

    # fuzzystrmatch was added early on but never actually used by any query
    # (search has always been a plain ILIKE) - pg_trgm is what powers the
    # new similarity-ranked search in GungeonSearch.Catalog.
    execute "DROP EXTENSION IF EXISTS fuzzystrmatch"

    execute "CREATE INDEX guns_name_trgm_idx ON guns USING gin (name gin_trgm_ops)"
    execute "CREATE INDEX guns_quote_trgm_idx ON guns USING gin (quote gin_trgm_ops)"
    execute "CREATE INDEX items_name_trgm_idx ON items USING gin (name gin_trgm_ops)"
    execute "CREATE INDEX items_quote_trgm_idx ON items USING gin (quote gin_trgm_ops)"
  end

  def down do
    execute "DROP INDEX IF EXISTS items_quote_trgm_idx"
    execute "DROP INDEX IF EXISTS items_name_trgm_idx"
    execute "DROP INDEX IF EXISTS guns_quote_trgm_idx"
    execute "DROP INDEX IF EXISTS guns_name_trgm_idx"

    execute "CREATE EXTENSION IF NOT EXISTS fuzzystrmatch"
    execute "DROP EXTENSION IF EXISTS pg_trgm"
  end
end
