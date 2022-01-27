defmodule Shopcash.Repo do
  use Ecto.Repo,
    otp_app: :shopcash,
    adapter: Ecto.Adapters.Postgres
end
