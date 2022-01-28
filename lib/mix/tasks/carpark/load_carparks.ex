defmodule Mix.Tasks.LoadCarparks do
  @moduledoc "The load carparks mix task: `mix help load_carparks`"
  use Mix.Task

  alias Shopcash.Govt

  @shortdoc "Simply calls the Govt.load_carparks/0 function."
  def run(_) do
    Mix.Task.run("app.start")
    :ok = Govt.load_carparks()
  end
end
