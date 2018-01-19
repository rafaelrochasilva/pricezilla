defmodule Pricezilla.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pricezilla,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
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
      {:postgrex, "~> 0.13.3"},
      {:ecto, "~> 2.2"}
    ]
  end
end
