defmodule Pricezilla.Product do
  use Ecto.Schema

  alias Pricezilla.PastPriceRecord
  alias Pricezilla.Repo

  schema "products" do
    field :external_product_id, :integer
    field :price, :integer
    field :product_name, :string
    has_many :past_price_records, PastPriceRecord

    timestamps()
  end

  def create(params) do
    sanitize_params = %{params | price: price_in_cents(params[:price])}
    change = changeset(%Pricezilla.Product{}, sanitize_params)

    Repo.insert!(change)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:external_product_id, :price, :product_name])
    |> Ecto.Changeset.validate_required([:external_product_id, :price, :product_name])
  end

  defp price_in_cents(price_string) do
    price =
      price_string
      |> String.trim("$")
      |> String.to_float

    round(price * 100)
  end
end
