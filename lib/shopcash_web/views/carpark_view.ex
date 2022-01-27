defmodule ShopcashWeb.CarparkView do
  use ShopcashWeb, :view
  alias ShopcashWeb.CarparkView

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
end
