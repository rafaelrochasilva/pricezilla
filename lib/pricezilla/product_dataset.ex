defmodule Pricezilla.ProductDataset do
  @moduledoc """
  Responsible for managing data: create, read and updates datasets.
  """
  require Logger

  alias Pricezilla.{Repo, Product, PastPriceRecord, PastPriceRecordSanitizer}

  @spec insert_product(map) :: {:ok, map} | {:error, binary}
  def insert_product(product) do
    cond do
      continued_and_new?(product) ->
        create(product)
      discontinued_and_new?(product) ->
        log_error_message(product)
      same_name_and_different_price?(product) ->
        create_past_price_record(product)
    end
  end

  @spec new_product?(number) :: boolean
  def new_product?(external_product_id) do
    case get_product_by(external_product_id) do
      nil -> true
      %Product{} -> false
    end
  end

  def get_product_by(external_product_id) do
    Repo.get_by(Product, external_product_id: external_product_id)
  end

  defp continued_and_new?(%{discontinued: discontinued, external_product_id: external_product_id}) do
    discontinued == false && new_product?(external_product_id)
  end

  defp discontinued_and_new?(%{discontinued: discontinued, external_product_id: external_product_id}) do
    discontinued == true && new_product?(external_product_id)
  end

  defp same_name_and_different_price?(%{product_name: name, price: price, external_product_id: external_product_id}) do
    fetched_product = get_product_by(external_product_id)

    fetched_product.product_name == name && fetched_product.price != price
  end

  defp log_error_message(%{external_product_id: external_product_id}) do
    message = "This product was discontinued and will not be saved"
    Logger.error "#{message}, external_product_id: #{external_product_id}"

    {:error, message}
  end

  defp create(product) do
    changeset = Product.changeset(product)

    case Repo.insert(changeset) do
      {:ok, product} ->
        Logger.info "Product created -> external_product_id: #{product.external_product_id}"
        {:ok, product}
      {:error, message} ->
        Logger.error "Could not create product -> external_product_id: #{product.external_product_id}"
        {:error, message}
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
        {:error, message}
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
