defmodule Pricezilla.PastPriceRecordMapperTest do
  use ExUnit.Case, async: true

  alias Pricezilla.PastPriceRecordMapper

  test "returns a sanitized map" do
    current_product = %{
      id: 1,
      external_product_id: 123_456,
      name: "Nice Chair",
      price: 2000
    }

    new_product = %{
      external_product_id: 123_456,
      name: "Nice Chair",
      price: 4000
    }

    expected_response = %{
      product_id: current_product.id,
      percentage_change: 100.0,
      price: current_product.price
    }

    assert PastPriceRecordMapper.convert(new_product, current_product) == expected_response
  end

  describe "calculates the percentage change" do
    test "increases prices" do
      current_price = 2000
      new_price = 4000

      assert PastPriceRecordMapper.percentage_change(current_price, new_price) == 100.0
    end

    test "decreases prices" do
      current_price = 4000
      new_price = 2000

      assert PastPriceRecordMapper.percentage_change(current_price, new_price) == -50.0
    end
  end
end
