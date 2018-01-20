defmodule Pricezilla.ProductDatasetTest do
  use ExUnit.Case, async: true

  alias Pricezilla.{Product, ProductDataset}

  setup do
    # Explicitly get a connection before each test
    # By default the test is wrapped in a transaction
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pricezilla.Repo)

    load_products_into_database()
  end

  describe "Verifies if it is a new product, given an external_product_id" do
    test "returns true if ir is a new product" do
      external_product_id = 1

      assert ProductDataset.new_product?(external_product_id) == true
    end

    test "returns false if a product already exists" do
      external_product_id = 123456

      assert ProductDataset.new_product?(external_product_id) == false
    end
  end

  describe "Given a new product, with an external_product_id not saved" do
    test "does not save a discontinued product" do
      product = %{
        category: "luggage",
        discontinued: true,
        external_product_id: 4323332,
        product_name: "Wallet",
        price: 1022
      }

      expected_response = {:error, "This product was discontinued and will not be saved"}

      assert ProductDataset.insert_product(product) == expected_response
    end

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
