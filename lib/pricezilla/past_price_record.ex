defmodule Pricezilla.PastPriceRecord do
  use Ecto.Schema

  schema "past_price_records" do
    field :product_id, :integer
    field :percentage_change, :float
    field :price, :integer

    timestamps()
  end

  def changeset(params \\ %{}) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, [:product_id, :percentage_change, :price])
    |> Ecto.Changeset.validate_required([:product_id, :percentage_change, :price])
  end
end
