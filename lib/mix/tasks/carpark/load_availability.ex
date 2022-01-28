defmodule Mix.Tasks.LoadAvailability do
  @moduledoc "The load availability mix task: `mix help load_availability`"
  use Mix.Task

  alias Shopcash.Govt

  @shortdoc "Simply calls the Govt.load_availability/0 function."
  def run(_) do
    Mix.Task.run("app.start")
    :ok = Govt.load_availability()
  end
end
