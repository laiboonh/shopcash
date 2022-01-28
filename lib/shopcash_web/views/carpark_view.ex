defmodule ShopcashWeb.CarparkView do
  use ShopcashWeb, :view
  alias ShopcashWeb.CarparkView

  def render("nearest.json", %{carparks: carparks}) do
    render_many(carparks, CarparkView, "availability.json")
  end

  def render("index.json", %{carparks: carparks}) do
    %{data: render_many(carparks, CarparkView, "carpark.json")}
  end

  def render("show.json", %{carpark: carpark}) do
    %{data: render_one(carpark, CarparkView, "carpark.json")}
  end

  def render("carpark.json", %{carpark: carpark}) do
    %{
      id: carpark.id,
      number: carpark.number,
      address: carpark.address,
      latitude: carpark.latitude,
      longitude: carpark.longitude
    }
  end

  def render("availability.json", %{carpark: carpark}) do
    %{
      address: carpark.address,
      latitude: carpark.latitude,
      longitude: carpark.longitude,
      total_lots: carpark.total_lots,
      available_lots: carpark.available_lots
    }
  end
end
