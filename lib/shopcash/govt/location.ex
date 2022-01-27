defmodule Shopcash.Govt.Location do
  defstruct latitude: 0.0, longitude: 0.0

  def new(x_coord, y_coord) do
    %{"latitude" => lat, "longitude" => lon} =
      Shopcash.Api.Carpark.svy21_to_wgs84(x_coord, y_coord)

    %__MODULE__{latitude: lat, longitude: lon}
  end
end
