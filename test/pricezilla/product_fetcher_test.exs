defmodule Pricezilla.ProductFetcherTest do
  use ExUnit.Case, async: true

  alias Pricezilla.ProductFetcher
  alias Pricezilla.FakeHttpClient

  test "returns a list of products" do
    products = "{\"productRecords\":[{\"price\":\"$30.25\",\"name\":\"Nice Chair\",\"id\":123456,\"discontinued\":false,\"category\":\"home-furnishings\"},{\"price\":\"$43.77\",\"name\":\"Black & White TV\",\"id\":234567,\"discontinued\":true,\"category\":\"electronics\"}]}"

    expected_response = %{
      "productRecords" => [
        %{
          "category" => "home-furnishings",
          "discontinued" => false,
          "id" => 123456,
          "name" => "Nice Chair",
          "price" => "$30.25"},
        %{
          "category" => "electronics",
          "discontinued" => true,
          "id" => 234567,
          "name" => "Black & White TV",
          "price" => "$43.77"
        }
      ]
    }

    assert ProductFetcher.get(FakeHttpClient) == {:ok, expected_response}
  end

  test "returns error when a given key is not provided" do
    url = "https://test.com/pricing/records.json?"
    message = "You must provide a valid authenticated access token."

    assert ProductFetcher.get(FakeHttpClient, url) == {:error, message}
  end
end
