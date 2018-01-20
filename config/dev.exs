use Mix.Config

# Configure database
config :pricezilla, Pricezilla.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pricezilla_dev",
  pool_size: 10,
  port: 5432

config :logger, :info,
  path: "log/dev/info.log",
  level: :info

config :logger, :error,
  path: "log/dev/error.log",
  level: :error
