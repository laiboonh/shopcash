defmodule ShopcashWeb.Router do
  use ShopcashWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShopcashWeb do
    pipe_through :api
    get "/carparks/nearest", CarparkController, :nearest
    resources "/carparks", CarparkController
  end
end
