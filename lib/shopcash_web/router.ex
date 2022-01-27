defmodule ShopcashWeb.Router do
  use ShopcashWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShopcashWeb do
    pipe_through :api
    resources "/carparks", CarparkController
  end
end
