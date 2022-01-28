defmodule Shopcash.Govt do
  @moduledoc """
  The Govt context.
  """

  import Ecto.Query, warn: false
  alias Shopcash.Repo

  alias Shopcash.Govt.Carpark
  alias Shopcash.Govt.Location
  alias NimbleCSV.RFC4180, as: CSV

  @carpark_information_file "../../priv/hdb-carpark-information.csv"

  def load_availability() do
    Shopcash.Api.Carpark.carpark_availability()
    |> Enum.each(fn info ->
      number = info["carpark_number"]
      {total_lots, available_lots} = aggregate_carpark_info(info["carpark_info"])
      update_availability(number, total_lots, available_lots)
    end)
  end

  defp aggregate_carpark_info(carpark_info) do
    Enum.reduce(carpark_info, {0, 0}, fn elem, {total, available} ->
      %{"total_lots" => t, "lots_available" => a} = elem
      {t, ""} = Integer.parse(t)
      {a, ""} = Integer.parse(a)
      {total + t, available + a}
    end)
  end

  def update_availability(number, total_lots, available_lots) do
    q = from "carparks", where: [number: ^number]
    Repo.update_all(q, set: [total_lots: total_lots, available_lots: available_lots])
  end

  def load_carparks(file \\ @carpark_information_file) do
    file
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.parse_stream()
    |> Stream.map(fn [car_park_no, address, x_coord, y_coord | _tail] ->
      location = Location.new(x_coord, y_coord)

      {:ok, _} =
        create_carpark(%{
          number: car_park_no,
          address: address,
          latitude: location.latitude,
          longitude: location.longitude
        })
    end)
    |> Stream.run()
  end

  @doc """
  Returns the list of carparks.

  ## Examples

      iex> list_carparks()
      [%Carpark{}, ...]

  """
  def list_carparks do
    Repo.all(Carpark)
  end

  @doc """
  Gets a single carpark.

  Raises `Ecto.NoResultsError` if the Carpark does not exist.

  ## Examples

      iex> get_carpark!(123)
      %Carpark{}

      iex> get_carpark!(456)
      ** (Ecto.NoResultsError)

  """
  def get_carpark!(id), do: Repo.get!(Carpark, id)

  @doc """
  Creates a carpark.

  ## Examples

      iex> create_carpark(%{field: value})
      {:ok, %Carpark{}}

      iex> create_carpark(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_carpark(attrs \\ %{}) do
    %Carpark{}
    |> Carpark.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a carpark.

  ## Examples

      iex> update_carpark(carpark, %{field: new_value})
      {:ok, %Carpark{}}

      iex> update_carpark(carpark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_carpark(%Carpark{} = carpark, attrs) do
    carpark
    |> Carpark.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a carpark.

  ## Examples

      iex> delete_carpark(carpark)
      {:ok, %Carpark{}}

      iex> delete_carpark(carpark)
      {:error, %Ecto.Changeset{}}

  """
  def delete_carpark(%Carpark{} = carpark) do
    Repo.delete(carpark)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking carpark changes.

  ## Examples

      iex> change_carpark(carpark)
      %Ecto.Changeset{data: %Carpark{}}

  """
  def change_carpark(%Carpark{} = carpark, attrs \\ %{}) do
    Carpark.changeset(carpark, attrs)
  end
end
