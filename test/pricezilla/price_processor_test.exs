defmodule Pricezilla.PriceProcessorTest do
  use ExUnit.Case, async: true

  alias Pricezilla.{Repo, Product, PriceProcessor, PastPriceRecord, FakeHttpClient}

  setup do
    # Explicitly get a connection before each test
    # By default the test is wrapped in a transaction
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pricezilla.Repo)
  end

  test "processes all products" do
    %Product{ external_product_id: "123456", name: "Nice Chair", price: 4000 }
    |> Pricezilla.Repo.insert

    current_nice_chair = Repo.get_by(Product, external_product_id: "123456")

    PriceProcessor.process(FakeHttpClient)

    new_nice_chair = Repo.get_by(Product, external_product_id: "123456")

    # We do not save discontinued products if thats whye we got 4 products.
    assert Repo.aggregate(Product, :count, :id) == 1
    refute new_nice_chair.price == current_nice_chair.price

    # Store the old product into PastPriceRecord with old price.
    assert Repo.aggregate(PastPriceRecord, :count, :id) == 1

    stored_record = Repo.get_by(PastPriceRecord, product_id: current_nice_chair.id)
    assert stored_record.price == current_nice_chair.price
  end
end
