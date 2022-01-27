defmodule Shopcash.Repo.Migrations.CreateCarparks do
  use Ecto.Migration

  def change do
    create table(:carparks) do
      add :address, :string, null: false
      add :latitude, :decimal, null: false
      add :longitude, :decimal, null: false

      timestamps()
    end
  end
end
