defmodule Shopcash.Govt do
  @moduledoc """
  The Govt context.
  """

  import Ecto.Query, warn: false
  alias Shopcash.Repo

  alias Shopcash.Govt.Carpark

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
