defmodule Pricezilla.ProductFetcher do
  @moduledoc """
  ProductFetcher is responsable to make real http requests with different clients.
  HTTPoision is used as a defauld driver to handle http requests.
  """

  @doc """
  Gets api response and returns the body when it succeds. When it fails it
  returns the error message.
  """
  @spec get(atom) :: {:ok, map} | {:error, binary}
  def get(client \\ HTTPoison, url \\ url_with_query()) do
    case client.get(url) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, Poison.decode!(body)}
      {:ok, %{status_code: _, body: body}} -> {:error, body}
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp url_with_query do
    url()
    |> URI.merge(query())
    |> to_string
  end

  defp url do
    System.get_env("OMEGA_PRICING_API_URL")
  end

  defp query do
    params = URI.encode_query(query_params())
    "?" <> params
  end

  def query_params do
    %{
      api_key: System.get_env("OMEGA_PRICING_API_KEY"),
      start_date: Timex.shift(Timex.today, days: -30),
      end_date: Timex.today
    }
  end
end
