defmodule Pricezilla.PastPriceRecordSanitizer do
  @moduledoc """
  Sanitizes the past price record to proper format
  """

  @spec sanitize(map, map) :: map
  def sanitize(product, current_product) do
    %{
      product_id: current_product.id,
      percentage_change: percentage_change(current_product.price, product.price),
      price: current_product.price
    }
  end

  @spec percentage_change(number, number) :: float
  def percentage_change(current_price, new_price) do
    (new_price - current_price) / current_price
  end
end
