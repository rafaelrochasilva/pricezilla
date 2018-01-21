defmodule Pricezilla.PriceProcessor do
  @moduledoc """
  The PriceProcessor is responsable to fetch the new data from external api,
  sanitize the products and save.
  """

  alias Pricezilla.{ProductFetcher, ProductSanitizer, ProductDataset, FakeHttpClient}

  @doc """
  Processes the products from an external api.
  In this case we are going to use FakeClient, since we don't have a client api.
  """

  def process(client \\ FakeHttpClient) do
    {:ok, products} = ProductFetcher.get(client)

    products
    |> ProductSanitizer.sanitize_all()
    |> ProductDataset.insert_all()

    :ok
  end
end
