defmodule Pricezilla.Product do
  use Ecto.Schema

  alias Pricezilla.PastPriceRecord

  schema "products" do
    field :external_product_id, :integer
    field :price, :integer
    field :product_name, :string
    has_many :past_price_records, PastPriceRecord

    timestamps()
  end

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, [:external_product_id, :price, :product_name])
    |> Ecto.Changeset.validate_required([:external_product_id, :price, :product_name])
  end
end
