defmodule ShopcashWeb.CarparkController do
  use ShopcashWeb, :controller

  alias Shopcash.Govt
  alias Shopcash.Govt.Carpark
  alias Shopcash.Govt.Location

  action_fallback ShopcashWeb.FallbackController

  defp nearest_params(params) do
    default = %{
      latitude: nil,
      longitude: nil
    }

    types = %{
      latitude: :float,
      longitude: :float
    }

    changeset =
      {default, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))
      |> Ecto.Changeset.validate_required([:latitude, :longitude])

    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end

  def nearest(conn, params) do
    with {:ok, valid_params} <- nearest_params(params) do
      current_location = %Location{
        latitude: valid_params.latitude,
        longitude: valid_params.longitude
      }

      carparks = Govt.nearest_available_carparks(current_location)
      render(conn, "nearest.json", carparks: carparks)
    end
  end

  def index(conn, _params) do
    carparks = Govt.list_carparks()
    render(conn, "index.json", carparks: carparks)
  end

  def create(conn, %{"carpark" => carpark_params}) do
    with {:ok, %Carpark{} = carpark} <- Govt.create_carpark(carpark_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.carpark_path(conn, :show, carpark))
      |> render("show.json", carpark: carpark)
    end
  end

  def show(conn, %{"id" => id}) do
    carpark = Govt.get_carpark!(id)
    render(conn, "show.json", carpark: carpark)
  end

  def update(conn, %{"id" => id, "carpark" => carpark_params}) do
    carpark = Govt.get_carpark!(id)

    with {:ok, %Carpark{} = carpark} <- Govt.update_carpark(carpark, carpark_params) do
      render(conn, "show.json", carpark: carpark)
    end
  end

  def delete(conn, %{"id" => id}) do
    carpark = Govt.get_carpark!(id)

    with {:ok, %Carpark{}} <- Govt.delete_carpark(carpark) do
      send_resp(conn, :no_content, "")
    end
  end
end
