use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :gungeon_search, GungeonSearchWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :gungeon_search, GungeonSearch.Repo,
  username: "postgres",
  password: "postgres",
  database: "gungeon_search_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
