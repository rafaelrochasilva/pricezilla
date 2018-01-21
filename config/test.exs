use Mix.Config

# Configure database
config :pricezilla, Pricezilla.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pricezilla_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: 5432

config :logger, level: :warn
config :logger, :info,
  path: "log/test/info.log",
  level: :info

config :logger, :error,
  path: "log/test/error.log",
  level: :error
