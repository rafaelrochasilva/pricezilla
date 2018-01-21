defmodule Pricezilla.PriceProcessor do
  @moduledoc """
  The PriceProcessor is responsable to fetch the new data from external api,
  sanitize the products and save.
  """
  use GenServer

  alias Pricezilla.{ProductFetcher, ProductSanitizer, ProductDataset, FakeHttpClient}

  @name :price_processor
  @time 30 * 24

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  # Server Callbacks

  def init(:ok) do
    IO.puts "Fetching prices.."
    initial_state = process()
    IO.puts "Products processed: #{inspect(initial_state)}"
    scheadule_refresh()
    {:ok, initial_state}
  end

  def handle_info(:refresh, _state) do
    IO.puts "Refreshing products..."
    new_state = process()
    IO.puts "Products processed: #{inspect(new_state)}"
    scheadule_refresh()
    {:noreply, new_state}
  end

  # We use monthly seconds to fetch data from api, but you can subistitute for
  # seconds scheduler, to test quickly using:
  #
  # Process.send_after(self(), :refresh, :timer.seconds(2))
  defp scheadule_refresh do
    Process.send_after(self(), :refresh, :timer.hours(@time))
  end

  @doc """
  Processes the products from an external api.
  In this case we are going to use FakeClient, since we don't have a client api.
  """
  def process(client \\ FakeHttpClient) do
    {:ok, products} = ProductFetcher.get(client)

    products
    |> ProductSanitizer.sanitize_all()
    |> ProductDataset.insert_all()
  end
end
