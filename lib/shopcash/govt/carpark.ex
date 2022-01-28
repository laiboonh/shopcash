defmodule Shopcash.Govt.Carpark do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carparks" do
    field :number, :string
    field :address, :string
    field :latitude, :float
    field :longitude, :float
    field :total_lots, :integer, default: 0
    field :available_lots, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(carpark, attrs) do
    carpark
    |> cast(attrs, [:number, :address, :latitude, :longitude, :total_lots, :available_lots])
    |> validate_required([:number, :address, :latitude, :longitude])
    |> unique_constraint(:number)
  end
end
