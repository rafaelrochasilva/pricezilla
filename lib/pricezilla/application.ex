defmodule Pricezilla.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = select_children()

    opts = [strategy: :one_for_one, name: Pricezilla.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def select_children do
    import Supervisor.Spec, warn: false

    case Mix.env() do
      :dev ->
        [supervisor(Pricezilla.Repo, []), worker(Pricezilla.PriceProcessor, [])]

      :test ->
        [supervisor(Pricezilla.Repo, [])]
    end
  end
end
