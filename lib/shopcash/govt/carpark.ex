defmodule Shopcash.Govt.Carpark do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carparks" do
    field :number, :string
    field :address, :string
    field :latitude, :decimal
    field :longitude, :decimal

    timestamps()
  end

  @doc false
  def changeset(carpark, attrs) do
    carpark
    |> cast(attrs, [:number, :address, :latitude, :longitude])
    |> validate_required([:number, :address, :latitude, :longitude])
    |> unique_constraint(:number)
  end
end
