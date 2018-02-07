defmodule Pricezilla.PastPriceRecordMapper do
  @moduledoc """
  Transforms the product struct to a past price record format. It also converts
  the price to percentage.
  """

  @spec convert(any, any) :: map
  def convert(product, current_product) do
    %{
      product_id: current_product.id,
      percentage_change: percentage_change(current_product.price, product.price),
      price: current_product.price
    }
  end

  @spec percentage_change(number, number) :: float
  def percentage_change(current_price, new_price) do
    (new_price - current_price) / current_price * 100
  end
end
