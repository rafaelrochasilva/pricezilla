defmodule Pricezilla.ProductMapper do
  @moduledoc """
  Maps the api response and use a proper format instead of using the API
  response format.
  """

  @doc """
  Maps the api response.
  """
  @spec convert_all(any) :: [map]
  def convert_all(params) do
    params["productRecords"]
    |> Enum.map(&convert_product/1)
  end

  @spec convert_product(map) :: map
  def convert_product(product) do
    %{
      category: product["category"],
      discontinued: product["discontinued"],
      external_product_id: Integer.to_string(product["id"]),
      name: product["name"],
      price: price_in_cents(product["price"])
    }
  end

  def price_in_cents(price_string) do
    price =
      price_string
      |> String.trim("$")
      |> String.to_float()

    round(price * 100)
  end
end
