defmodule Pricezilla.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pricezilla,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Pricezilla.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:httpoison, "~> 1.0"},
      {:poison, ">= 1.0.0"},
      {:timex, "~> 3.1"},
      {:logger_file_backend, "~> 0.0.10"},
      {:postgrex, "~> 0.13.3"},
      {:ecto, "~> 2.2"}
    ]
  end

  defp aliases do
    [
      "ecto.test.prepare": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
