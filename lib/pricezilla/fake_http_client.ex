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
    random = random_data()
    %{
      body: fetch_products(random: random),
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

  defp fetch_products(random: false) do
    "{\"productRecords\":[{\"price\":\"$30.25\",\"name\":\"Nice Chair\",\"id\":123456,\"discontinued\":false,\"category\":\"home-furnishings\"},{\"price\":\"$43.77\",\"name\":\"Black & White TV\",\"id\":234567,\"discontinued\":true,\"category\":\"electronics\"}]}"
  end

  defp fetch_products(random: true) do
    %{ productRecords: dynamic_data() }
    |> Poison.encode!
  end

  defp random_data() do
    case Mix.env do
      :dev -> true
      :test -> false
    end
  end

  defp dynamic_data do
    for _ <- (1..4) do
      %{
        "category" => Enum.random(categories()),
        "discontinued" => Enum.random([true, false]),
        "id" => Enum.random(ids()),
        "name" => Enum.random(names()),
        "price" => Enum.random(prices())
      }
    end
  end

  defp categories do
    ["electronics", "home-furnishing", "sports"]
  end

  defp ids do
    [12345, 12346, 12347, 123458]
  end

  defp prices do
    ["$13.41", "$45.23", "$345.43", "$76.43"]
  end

  defp names do
    ["generic_1","generic_2","generic_3","generic_4","generic_5"]
  end
end
