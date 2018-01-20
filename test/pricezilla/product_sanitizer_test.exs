defmodule Pricezilla.ProductSanitizerTest do
  use ExUnit.Case, async: true

  alias Pricezilla.ProductSanitizer

  test "returns a sanitized map" do
    products = %{
      "productRecords" => [
        %{
          "category" => "home-furnishings",
          "discontinued" => false,
          "id" => 123456,
          "name" => "Nice Chair",
          "price" => "$30.25"
        }
      ]
    }

    expected_response = [
      %{
        category: "home-furnishings",
        discontinued: false,
        external_product_id: 123456,
        product_name: "Nice Chair",
        price: 3025
      }
    ]

    assert ProductSanitizer.sanitize(products) == expected_response
  end

  test "sanitizes a given product" do
    product = %{
      "category" => "home-furnishings",
      "discontinued" => false,
      "id" => 123456,
      "name" => "Nice Chair",
      "price" => "$30.25"
    }

    expected_response = %{
      category: "home-furnishings",
      discontinued: false,
      external_product_id: 123456,
      product_name: "Nice Chair",
      price: 3025
    }

    assert ProductSanitizer.sanitize_product(product) == expected_response
  end

  test "converts the price in dollar string to cents integer" do
    price_in_dollar = "$100.01"

    assert ProductSanitizer.price_in_cents(price_in_dollar) == 10001
  end
end
