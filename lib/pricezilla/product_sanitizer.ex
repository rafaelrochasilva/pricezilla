defmodule Pricezilla.ProductSanitizer do
  @moduledoc """
  Sanitizes the api response and use a proper format instead of using the API
  response format.
  """

  @doc """
  Sanitizes the api response.
  """
  @spec sanitize(map) :: map
  def sanitize(params) do
    params["productRecords"]
    |> Enum.map(&sanitize_product/1)
  end

  def sanitize_product(product) do
    %{
      category: product["category"],
      discontinued: product["discontinued"],
      external_product_id: product["id"],
      product_name: product["name"],
      price: price_in_cents(product["price"])
    }
  end

  def price_in_cents(price_string) do
    price =
      price_string
      |> String.trim("$")
      |> String.to_float

    round(price * 100)
  end
end
