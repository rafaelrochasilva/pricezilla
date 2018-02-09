defmodule Pricezilla.Product do
  use Ecto.Schema

  alias Pricezilla.PastPriceRecord

  schema "products" do
    field(:external_product_id, :string)
    field(:price, :integer)
    field(:name, :string)
    has_many(:past_price_records, PastPriceRecord)

    timestamps()
  end

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, [:external_product_id, :price, :name])
    |> Ecto.Changeset.validate_required([:external_product_id, :price, :name])
    |> validate_continued(params.discontinued)
  end

  def changeset(current_product, new_product) do
    current_product
    |> Ecto.Changeset.cast(new_product, [:price, :name])
    |> Ecto.Changeset.validate_required([:price, :name])
    |> different_price(current_product.price, new_product.price)
    |> Ecto.Changeset.validate_change(:name, fn :name, name ->
      same_name(name, current_product.name)
    end)
  end

  def validate_continued(changeset, discontinued) do
    case discontinued == false do
      false ->
        Ecto.Changeset.add_error(
          changeset,
          :discontinued,
          "cannot save a discontinued product"
        )

      true ->
        changeset
    end
  end

  defp same_name(new_name, current_name) do
    case new_name == current_name do
      true -> []
      false -> [name: "cannot use a different product name"]
    end
  end

  defp different_price(changeset, current_price, new_price) do
    case current_price == new_price do
      true ->
        Ecto.Changeset.add_error(
          changeset,
          :price,
          "cannot save a same price product"
        )

      false ->
        changeset
    end
  end
end
