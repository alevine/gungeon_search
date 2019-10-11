# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gungeon_search,
  ecto_repos: [GungeonSearch.Repo]

# Configures the endpoint
config :gungeon_search, GungeonSearchWeb.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "localhost"],
  secret_key_base: "nRMsEt+d4/ynzmui7aItkuVVilccM2djTlKtg5hBbO/LFEnlXSY74jrrdrTLRHQ9",
  render_errors: [view: GungeonSearchWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GungeonSearch.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
