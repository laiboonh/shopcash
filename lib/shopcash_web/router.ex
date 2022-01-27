defmodule ShopcashWeb.Router do
  use ShopcashWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ShopcashWeb do
    pipe_through :api
  end
end
