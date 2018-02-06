defmodule Pricezilla.PriceProcessorTest do
  use ExUnit.Case, async: true

  alias Pricezilla.{Repo, Product, PriceProcessor, PastPriceRecord, FakeHttpClient}

  setup do
    # Explicitly get a connection before each test
    # By default the test is wrapped in a transaction
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pricezilla.Repo)

    load_products_into_database()
  end

  test "processes all products" do
    # API products:
    # [%{id: 123456, name: "Nice Chair", price: $30.25, discontinued: false}
    # [%{id: 123456, name: "Nice Chair", price: $43.77, discontinued: true}
    #
    current_nice_chair = Repo.get_by(Product, external_product_id: "123456")

    PriceProcessor.process(FakeHttpClient)

    new_nice_chair = Repo.get_by(Product, external_product_id: "123456")

    # We do not save discontinued products if thats whye we got 4 products.
    assert Repo.aggregate(Product, :count, :id) == 4
    refute new_nice_chair.price == current_nice_chair.price

    # Store the old product into PastPriceRecord with old price.
    assert Repo.aggregate(PastPriceRecord, :count, :id) == 1

    stored_record = Repo.get_by(PastPriceRecord, product_id: current_nice_chair.id)
    assert stored_record.price == current_nice_chair.price
  end

  defp load_products_into_database do
    products = [
      %Product{ external_product_id: "123456", name: "Nice Chair", price: 4000 },
      %Product{ external_product_id: "123457", name: "Surf Board", price: 10000 },
      %Product{ external_product_id: "234567", name: "TV", price: 14000 },
      %Product{ external_product_id: "123459", name: "Watch", price: 7000 }
    ]

    Enum.each(products, fn (product) -> Pricezilla.Repo.insert(product) end)
  end
end
