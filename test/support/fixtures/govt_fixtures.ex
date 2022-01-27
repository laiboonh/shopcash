defmodule Shopcash.GovtFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shopcash.Govt` context.
  """

  @doc """
  Generate a carpark.
  """
  def carpark_fixture(attrs \\ %{}) do
    {:ok, carpark} =
      attrs
      |> Enum.into(%{
        address: "some address",
        latitude: "120.5",
        longitude: "120.5"
      })
      |> Shopcash.Govt.create_carpark()

    carpark
  end
end
