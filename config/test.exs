use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure database
config :pricezilla, Pricezilla.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pricezilla_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: 5432
