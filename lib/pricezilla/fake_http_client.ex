defmodule Pricezilla.FakeHttpClient do
  @moduledoc """
  FakeHttpClient simulates the interaction with the OmegaPricingInc. It's main
  propose is return a fake products and validates if the token, and dates are
  present.
  """

  @doc """
  Simulates a get request to the API and returns ok if the tokens and dates
  are present.
  """
  @spec get(binary) :: {:ok, map}
  def get(url) do
    case verify_query_string(url) do
      :ok -> {:ok, response()}
      {:error, message} -> {:ok, response_error(message)}
    end
  end

  defp verify_query_string(url) do
    cond do
      !String.match?(url, ~r/api_key/) ->
        {:error, "You must provide a valid authenticated access token."}
      !String.match?(url, ~r/start_date/) ->
        {:error, "You must provide a start_date."}
      !String.match?(url, ~r/end_date/) ->
        {:error, "You must provide a end_date."}
      true -> :ok
    end
  end

  defp response do
    %{
      body: fetch_products(),
      headers: [{"Connection", "keep-alive"}],
      status_code: 200
    }
  end

  defp response_error(message) do
    %{
      body: message,
      headers: [{"Connection", "keep-alive"}],
      status_code: 401
    }
  end

  defp fetch_products do
    "{\"productRecords\":[{\"price\":\"$30.25\",\"name\":\"Nice Chair\",\"id\":123456,\"discontinued\":false,\"category\":\"home-furnishings\"},{\"price\":\"$43.77\",\"name\":\"Black & White TV\",\"id\":234567,\"discontinued\":true,\"category\":\"electronics\"}]}"
  end
end
