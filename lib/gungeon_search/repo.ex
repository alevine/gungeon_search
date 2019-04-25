defmodule GungeonSearch.Repo do
  use Ecto.Repo,
    otp_app: :gungeon_search,
    adapter: Ecto.Adapters.Postgres
end
