defmodule Pricezilla.ProductMapperTest do
  use ExUnit.Case, async: true

  alias Pricezilla.ProductMapper

  test "returns a converted map" do
    products = %{
      "productRecords" => [
        %{
          "category" => "home-furnishings",
          "discontinued" => false,
          "id" => 123_456,
          "name" => "Nice Chair",
          "price" => "$30.25"
        }
      ]
    }

    expected_response = [
      %{
        category: "home-furnishings",
        discontinued: false,
        external_product_id: "123456",
        name: "Nice Chair",
        price: 3025
      }
    ]

    assert ProductMapper.convert_all(products) == expected_response
  end

  test "convert to a proper format a given product" do
    product = %{
      "category" => "home-furnishings",
      "discontinued" => false,
      "id" => 123_456,
      "name" => "Nice Chair",
      "price" => "$30.25"
    }

    expected_response = %{
      category: "home-furnishings",
      discontinued: false,
      external_product_id: "123456",
      name: "Nice Chair",
      price: 3025
    }

    assert ProductMapper.convert_product(product) == expected_response
  end

  test "converts the price in dollar string to cents integer" do
    price_in_dollar = "$100.01"

    assert ProductMapper.price_in_cents(price_in_dollar) == 10001
  end
end
