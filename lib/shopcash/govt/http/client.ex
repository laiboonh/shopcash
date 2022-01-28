defmodule Shopcash.Govt.Http.Client do
  def svy21_to_wgs84(x_coord, y_coord) do
    url = "https://developers.onemap.sg/commonapi/convert/3414to4326?X=#{x_coord}&Y=#{y_coord}"

    case HTTPoison.get(url, [], hackney: [pool: :default]) do
      {:ok, %{status_code: 200, body: body}} ->
        Jason.decode!(body)

      {:ok, _} ->
        nil
    end
  end

  def carpark_availability() do
    url = "https://api.data.gov.sg/v1/transport/carpark-availability"

    case HTTPoison.get(url, [], hackney: [pool: :default]) do
      {:ok, %{status_code: 200, body: body}} ->
        [data] = Jason.decode!(body)["items"]
        data["carpark_data"]

      {:ok, _} ->
        nil
    end
  end
end
