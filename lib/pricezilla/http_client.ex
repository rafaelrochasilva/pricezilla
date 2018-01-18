defmodule Pricezilla.HttpClient do

  @moduledoc """
  HttpClient is responsable to make real http requests with different clients.
  HTTPoision is used as a defauld driver to handle http requests.
  """

  @doc """
  Gets api response and returns the body when it succeds. When it fails it
  returns the error message.
  """
  @spec get(atom) :: {:ok, map} | {:error, binary}
  def get(client \\ HTTPoison, url \\ url_with_query() ) do
    case client.get(url) do
      {:ok, %{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %{status_code: 401, body: body}} -> {:error, body}
    end
  end

  defp url_with_query do
    url() <> query()
  end

  defp query do
    "?token=#{token()}&start_date=#{start_date()}&end_date=#{end_date()}"
  end

  defp start_date do
    Timex.shift(Timex.today, days: 1)
  end

  defp end_date do
    Timex.today
  end

  defp token do
    System.get_env("OMEGA_PRICING_API_KEY")
  end

  defp url do
    System.get_env("OMEGA_PRICING_API_URL")
  end
end
