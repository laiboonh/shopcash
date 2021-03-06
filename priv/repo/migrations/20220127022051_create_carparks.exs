defmodule Shopcash.Repo.Migrations.CreateCarparks do
  use Ecto.Migration

  def change do
    create table(:carparks) do
      add :number, :string, null: false
      add :address, :string, null: false
      add :latitude, :float, null: false
      add :longitude, :float, null: false

      timestamps()
    end

    create index("carparks", [:number], unique: true)
  end
end
