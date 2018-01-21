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

  @spec insert_product(map) :: {:ok, map} | {:error, binary}
  def insert_product(product) do
    cond do
      continued_and_new?(product) ->
        create(product)
      same_name_and_different_price?(product) ->
        create_past_price_record(product)
      existing_product_with_different_name?(product) ->
        log_name_error_message(product)
    end
  end

  @spec get_product_by(number) :: map | nil
  def get_product_by(external_product_id) do
    Repo.get_by(Product, external_product_id: external_product_id)
  end

  defp continued_and_new?(%{discontinued: discontinued, external_product_id: external_product_id}) do
    discontinued == false && get_product_by(external_product_id) == nil
  end

  defp same_name_and_different_price?(%{product_name: name, price: price, external_product_id: external_product_id}) do
    fetched_product = get_product_by(external_product_id)

    fetched_product.product_name == name && fetched_product.price != price
  end

  defp existing_product_with_different_name?(%{product_name: name, external_product_id: external_product_id}) do
    fetched_product = get_product_by(external_product_id)

    name != fetched_product.product_name
  end

  def log_name_error_message(product) do
    message = "This product has a different name and can not be saved #{inspect(product)}"
    Logger.error(message)
    {:error, message}
  end

  defp create(product) do
    changeset = Product.changeset(product)

    case Repo.insert(changeset) do
      {:ok, product} ->
        Logger.info "Product created -> external_product_id: #{product.external_product_id}"
        {:ok, product}
      {:error, message} ->
        Logger.error "Could not create product -> #{message}"
    end
  end

  defp create_past_price_record(new_product) do
    current_product = get_product_by(new_product.external_product_id)

    changeset =
      new_product
      |> PastPriceRecordSanitizer.sanitize(current_product)
      |> PastPriceRecord.changeset

    case Repo.insert(changeset) do
      {:ok, past_price_record} ->
        Logger.info "Past price record created: #{past_price_record.id}"
        update(current_product, new_product, past_price_record)
      {:error, message} ->
        Logger.error "Could not create past price record: #{message}"
    end
  end

  defp update(current_product, new_product, past_price_record) do
    changeset = Product.changeset(current_product, new_product)

    case Repo.update(changeset) do
      {:ok, product_updated} ->
        Logger.info "Product updated -> external_product_id: #{product_updated.external_product_id}"
        {:ok, product_updated, past_price_record}
      {:error, message} ->
        Logger.error "Could not update product -> external_product_id: #{current_product.external_product_id}, message: #{message}"
        {:error, message}
    end
  end
end
