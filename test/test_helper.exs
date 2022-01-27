ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Shopcash.Repo, :manual)

Mox.defmock(Shopcash.Govt.Http.MockClient, for: Shopcash.Api.Carpark)
Application.put_env(:shopcash, :carpark_api, Shopcash.Govt.Http.MockClient)
