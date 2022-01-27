defmodule Shopcash.Govt.Carpark do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carparks" do
    field :address, :string
    field :latitude, :decimal
    field :longitude, :decimal

    timestamps()
  end

  @doc false
  def changeset(carpark, attrs) do
    carpark
    |> cast(attrs, [:address, :latitude, :longitude])
    |> validate_required([:address, :latitude, :longitude])
  end
end
