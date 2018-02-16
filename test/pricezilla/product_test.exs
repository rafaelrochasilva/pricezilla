defmodule Pricezilla.ProductTest do
  use ExUnit.Case, async: true
  alias Pricezilla.Product

  describe "validate changeset for a new product" do
    test "changeset with valid attributes" do
      changeset =
        %{price: 100, name: "Sunglasses", discontinued: false, external_product_id: "1234"}
        |> Product.changeset()

      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset =
        %{price: 100, discontinued: false, external_product_id: "1234"}
        |> Product.changeset()

      assert changeset.valid? == false
    end

    test "changeset with discontinued product" do
      changeset =
        %{price: 100, name: "Sunglasses", discontinued: true, external_product_id: "1234"}
        |> Product.changeset()

      assert changeset.valid? == false
      assert changeset.errors == [{:discontinued, {"cannot save a discontinued product", []}}]
    end
  end

  describe "validate changeset for a existing product" do
    test "product with new price" do
      current_product = %Product{
        price: 100,
        name: "Sunglasses",
        discontinued: false,
        external_product_id: "1234"
      }

      new_product = %{
        price: 300,
        name: "Sunglasses",
        discontinued: false,
        external_product_id: "1234"
      }

      changeset = Product.changeset(current_product, new_product)

      assert changeset.valid?
    end

    test "same product with different name" do
      current_product = %Product{
        price: 100,
        name: "Sunglasses",
        discontinued: false,
        external_product_id: "1234"
      }

      new_product = %{
        price: 300,
        name: "Glasses",
        discontinued: false,
        external_product_id: "1234"
      }

      changeset = Product.changeset(current_product, new_product)

      assert changeset.valid? == false
    end
  end
end
