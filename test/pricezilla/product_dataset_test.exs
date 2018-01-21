defmodule Pricezilla.ProductDatasetTest do
  use ExUnit.Case, async: true

  alias Pricezilla.{Product, ProductDataset}

  setup do
    # Explicitly get a connection before each test
    # By default the test is wrapped in a transaction
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pricezilla.Repo)

    load_products_into_database()
  end

  describe "Given a new product, with an external_product_id not saved" do
    test "saves a continued product" do
      product = %{
        category: "footwear",
        discontinued: false,
        external_product_id: 7354645,
        product_name: "Flip Flop",
        price: 7022
      }

      {:ok, product_created} = ProductDataset.insert_product(product)

      assert product_created.external_product_id == 7354645
      assert product_created.price == 7022
      assert product_created.product_name == "Flip Flop"
    end
  end

  describe "Given an existing product, with same name and price differs" do
    test "creates a new past price record and update product price for a discontinued product" do
      external_product_id = 123456
      existing_product = ProductDataset.get_product_by(external_product_id)
      new_product = %{
        category: "home-furnishings",
        discontinued: true,
        external_product_id: external_product_id,
        product_name: "Nice Chair",
        price: 8000
      }

      {:ok, product_created, past_price_record} = ProductDataset.insert_product(new_product)

      assert product_created.external_product_id == external_product_id
      refute product_created.price == existing_product.price
      assert product_created.price == 8000
      assert past_price_record.product_id == existing_product.id
      assert past_price_record.price == existing_product.price
    end

    test "creates a new past price record and update product price for a continued product" do
      external_product_id = 123457
      existing_product = ProductDataset.get_product_by(external_product_id)
      new_product = %{
        category: "sports",
        discontinued: false,
        external_product_id: external_product_id,
        product_name: "Surf Board",
        price: 6000
      }

      {:ok, product_created, past_price_record} = ProductDataset.insert_product(new_product)

      assert product_created.external_product_id == external_product_id
      refute product_created.price == existing_product.price
      assert product_created.price == 6000
      assert past_price_record.product_id == existing_product.id
      assert past_price_record.price == existing_product.price
    end
  end

  # If there is an existing product record with a matching external_product_id,
  # but a different product name, log an error message that warns the team that
  # there is a mismatch. Do not update the price.
  describe "Given an existing product, with different name" do
    test "logs a error message" do
      product = %{
        category: "sports",
        discontinued: false,
        external_product_id: 123457,
        product_name: "Cool Board",
        price: 6000
      }

      {:error, message} = ProductDataset.insert_product(product)

      expected_message = Regex.match?(
        ~r/This product has a different name and can not be saved/,
        message
      )

      assert expected_message == true
    end
  end

  defp load_products_into_database() do
    products = [
      %Product{ external_product_id: 123456, product_name: "Nice Chair", price: 4000 },
      %Product{ external_product_id: 123457, product_name: "Surf Board", price: 10000 },
      %Product{ external_product_id: 234567, product_name: "TV", price: 14000 },
      %Product{ external_product_id: 123459, product_name: "Watch", price: 7000 }
    ]

    Enum.each(products, fn (product) -> Pricezilla.Repo.insert(product) end)
  end
end
