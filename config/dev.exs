use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure database
config :pricezilla, Pricezilla.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "pricezilla_dev",
  pool: 10,
  port: 5432




