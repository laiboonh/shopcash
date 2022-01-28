defmodule Shopcash.Govt.Location do
  defstruct latitude: 0.0, longitude: 0.0

  def new(x_coord, y_coord) do
    %{"latitude" => lat, "longitude" => lon} =
      Shopcash.Api.Carpark.svy21_to_wgs84(x_coord, y_coord)

    %__MODULE__{latitude: lat, longitude: lon}
  end

  def distance_in_km(%__MODULE__{latitude: lat1, longitude: lon1}, %__MODULE__{
        latitude: lat2,
        longitude: lon2
      }) do
    # Radius of the earth in km
    earth_radius = 6371
    dLat = deg2rad(lat2 - lat1)
    dLon = deg2rad(lon2 - lon1)

    a =
      :math.sin(dLat / 2) * :math.sin(dLat / 2) +
        :math.cos(deg2rad(lat1)) * :math.cos(deg2rad(lat2)) *
          :math.sin(dLon / 2) * :math.sin(dLon / 2)

    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))
    # Distance in km
    earth_radius * c
  end

  defp deg2rad(deg) do
    deg * (:math.pi() / 180)
  end
end
