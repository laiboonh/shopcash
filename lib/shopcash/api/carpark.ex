defmodule Shopcash.Api.Carpark do
  @callback svy21_to_wgs84(float(), float()) :: nil | map()
  @callback carpark_availability() :: nil | list(map())

  def svy21_to_wgs84(x_coord, y_coord), do: impl().svy21_to_wgs84(x_coord, y_coord)
  def carpark_availability(), do: impl().carpark_availability()
  defp impl, do: Application.get_env(:shopcash, :carpark_api, Shopcash.Govt.Http.Client)
end
