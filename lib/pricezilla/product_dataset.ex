defmodule Pricezilla.ProductDataset do
  @moduledoc """
  Responsible for managing data: create, read and updates datasets.
  """
  require Logger

  alias Pricezilla.{Repo, Product}

  @spec insert_product(map) :: {:ok, map} | {:error, binary}
  def insert_product(product) do
    cond do
      continued_and_new?(product) ->
        create(product)
      discontinued_and_new?(product) ->
        log_error_message(product)
    end
  end

  @spec new_product?(number) :: boolean
  def new_product?(external_product_id) do
    case get_product_by(external_product_id) do
      nil -> true
      %Product{} -> false
    end
  end

  defp get_product_by(external_product_id) do
    Repo.get_by(Product, external_product_id: external_product_id)
  end

  defp continued_and_new?(%{discontinued: discontinued, external_product_id: external_product_id}) do
    discontinued == false && new_product?(external_product_id)
  end

  defp discontinued_and_new?(%{discontinued: discontinued, external_product_id: external_product_id}) do
    discontinued == true && new_product?(external_product_id)
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
end
