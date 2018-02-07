defmodule Pricezilla.ProductDataset do
  @moduledoc """
  Responsible for managing data: create, read and updates datasets.
  """
  require Logger

  alias Pricezilla.{Repo, Product, PastPriceRecord, PastPriceRecordMapper}

  @spec insert_all([map]) :: [map]
  def insert_all(products) do
    Enum.map(products, &insert_product/1)
  end

  @spec insert_product(map) :: {:ok, any} | {:error, binary}
  def insert_product(new_product) do
    current_product = Repo.get_by(
      Product, external_product_id: new_product.external_product_id
    )

    case current_product do
      nil -> create(new_product)
      _ -> update(current_product, new_product)
    end
  end

  defp create(product) do
    changeset = Product.changeset(product)

    case Repo.insert(changeset) do
      {:ok, new_product} ->
        Logger.info "[Time] #{Timex.now} [Product created] #{inspect new_product}"
        {:ok, new_product}
      {:error, changeset} ->
        Logger.error "[Time] #{Timex.now} [Error message] #{inspect changeset}"
        {:error, changeset.errors}
    end
  end

  defp update(current_product, new_product) do
    product =
      current_product
      |> Repo.preload(:past_price_records)
      |> Product.changeset(new_product)

    past_price_record =
      new_product
      |> PastPriceRecordMapper.convert(current_product)
      |> PastPriceRecord.changeset()

    product_with_record = Ecto.Changeset.put_assoc(product, :past_price_records, [past_price_record])

    Repo.transaction fn ->
      case Repo.update(product_with_record) do
        {:ok, product_updated} ->
          Logger.info "[Time] #{Timex.now} [Product updated] #{inspect product_updated}"
          product_updated
        {:error, changeset} ->
          Logger.error "[Time] #{Timex.now} [Error message] #{inspect changeset}"
          Repo.rollback(changeset)
      end
    end
  end
end
