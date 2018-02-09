defmodule Pricezilla.FakeHttpClientTest do
  use ExUnit.Case, async: true

  test "returns a list of products" do
    url =
      "https://test.com/pricing/records.json?api_key=1234-AAAA-BBBBBB-CCC&start_date=2017-12-17&end_date=2018-01-17"

    expected_response = %{
      headers: [{"Connection", "keep-alive"}],
      status_code: 200,
      body:
        "{\"productRecords\":[{\"price\":\"$30.25\",\"name\":\"Nice Chair\",\"id\":123456,\"discontinued\":false,\"category\":\"home-furnishings\"},{\"price\":\"$43.77\",\"name\":\"Black & White TV\",\"id\":234567,\"discontinued\":true,\"category\":\"electronics\"}]}"
    }

    assert Pricezilla.FakeHttpClient.get(url) == {:ok, expected_response}
  end

  test "returns a invalid token message" do
    url = "https://test.com/pricing/records.json?start_date=2017-12-17&end_date=2018-01-17"

    {:ok, response} = Pricezilla.FakeHttpClient.get(url)

    assert response.status_code == 401
    assert response.body == "You must provide a valid authenticated access token."
  end

  test "returns a invalid start_date message" do
    url = "https://test.com/pricing/records.json?api_key=1234-AAAA-BBBBBB-CCC&end_date=2018-01-17"

    {:ok, response} = Pricezilla.FakeHttpClient.get(url)

    assert response.status_code == 401
    assert response.body == "You must provide a start_date."
  end

  test "returns a invalid end_date message" do
    url =
      "https://test.com/pricing/records.json?api_key=1234-AAAA-BBBBBB-CCC&start_date=2018-01-17"

    {:ok, response} = Pricezilla.FakeHttpClient.get(url)

    assert response.status_code == 401
    assert response.body == "You must provide a end_date."
  end
end
