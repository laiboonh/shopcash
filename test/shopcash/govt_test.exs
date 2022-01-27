defmodule Shopcash.GovtTest do
  use Shopcash.DataCase

  alias Shopcash.Govt

  describe "carparks" do
    alias Shopcash.Govt.Carpark

    import Shopcash.GovtFixtures

    @invalid_attrs %{address: nil, latitude: nil, longitude: nil}

    test "list_carparks/0 returns all carparks" do
      carpark = carpark_fixture()
      assert Govt.list_carparks() == [carpark]
    end

    test "get_carpark!/1 returns the carpark with given id" do
      carpark = carpark_fixture()
      assert Govt.get_carpark!(carpark.id) == carpark
    end

    test "create_carpark/1 with valid data creates a carpark" do
      valid_attrs = %{address: "some address", latitude: "120.5", longitude: "120.5"}

      assert {:ok, %Carpark{} = carpark} = Govt.create_carpark(valid_attrs)
      assert carpark.address == "some address"
      assert carpark.latitude == Decimal.new("120.5")
      assert carpark.longitude == Decimal.new("120.5")
    end

    test "create_carpark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Govt.create_carpark(@invalid_attrs)
    end

    test "update_carpark/2 with valid data updates the carpark" do
      carpark = carpark_fixture()
      update_attrs = %{address: "some updated address", latitude: "456.7", longitude: "456.7"}

      assert {:ok, %Carpark{} = carpark} = Govt.update_carpark(carpark, update_attrs)
      assert carpark.address == "some updated address"
      assert carpark.latitude == Decimal.new("456.7")
      assert carpark.longitude == Decimal.new("456.7")
    end

    test "update_carpark/2 with invalid data returns error changeset" do
      carpark = carpark_fixture()
      assert {:error, %Ecto.Changeset{}} = Govt.update_carpark(carpark, @invalid_attrs)
      assert carpark == Govt.get_carpark!(carpark.id)
    end

    test "delete_carpark/1 deletes the carpark" do
      carpark = carpark_fixture()
      assert {:ok, %Carpark{}} = Govt.delete_carpark(carpark)
      assert_raise Ecto.NoResultsError, fn -> Govt.get_carpark!(carpark.id) end
    end

    test "change_carpark/1 returns a carpark changeset" do
      carpark = carpark_fixture()
      assert %Ecto.Changeset{} = Govt.change_carpark(carpark)
    end
  end
end
