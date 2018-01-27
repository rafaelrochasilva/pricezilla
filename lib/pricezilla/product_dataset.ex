defmodule Pricezilla.ProductDataset do
  @moduledoc """
  Responsible for managing data: create, read and updates datasets.
  """
  require Logger

  alias Pricezilla.{Repo, Product, PastPriceRecord, PastPriceRecordSanitizer}

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
        Logger.info "Product created -> external_product_id: #{new_product.external_product_id}"
        {:ok, new_product}
      {:error, changeset} ->
        Logger.error "#{inspect changeset}"
        {:error, changeset.errors}
    end
  end

  defp update(current_product, new_product) do
    changeset = Product.changeset(current_product, new_product)

    case Repo.update(changeset) do
      {:ok, product_updated} ->
        Logger.info "Product updated -> external_product_id: #{product_updated.external_product_id}"
        create_past_price_record(current_product, product_updated)
      {:error, changeset} ->
        Logger.error "#{inspect changeset}"
        {:error, changeset.errors}
    end
  end

  defp create_past_price_record(current_product, new_product) do
    changeset =
      new_product
      |> PastPriceRecordSanitizer.sanitize(current_product)
      |> PastPriceRecord.changeset

    case Repo.insert(changeset) do
      {:ok, past_price_record} ->
        Logger.info "Past price record created: #{past_price_record.id}"
        {:ok, new_product, past_price_record}
      {:error, changeset} ->
        Logger.error "#{inspect changeset}"
        {:error, changeset.errors}
    end
  end
end
