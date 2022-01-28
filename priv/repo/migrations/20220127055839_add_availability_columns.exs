defmodule Shopcash.Repo.Migrations.AddAvailabilityColumns do
  use Ecto.Migration

  def change do
    alter table("carparks") do
      add :total_lots, :integer, null: false, default: 0
      add :available_lots, :integer, null: false, default: 0
    end
  end
end
