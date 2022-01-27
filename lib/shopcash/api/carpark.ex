defmodule Shopcash.Api.Carpark do
  @callback svy21_to_wgs84(float(), float()) :: nil | map()

  def svy21_to_wgs84(x_coord, y_coord), do: impl().svy21_to_wgs84(x_coord, y_coord)
  defp impl, do: Application.get_env(:shopcash, :carpark_api, Shopcash.Govt.Http.Client)
end
