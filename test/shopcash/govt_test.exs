defmodule Shopcash.GovtTest do
  use Shopcash.DataCase

  import Mox

  alias Shopcash.Govt
  alias Shopcash.Govt.Location

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  describe "carparks" do
    alias Shopcash.Govt.Carpark

    import Shopcash.GovtFixtures

    @invalid_attrs %{address: nil, latitude: nil, longitude: nil}

    test "nearest_carparks/1" do
      # no available lots
      _carpark_a = carpark_fixture(%{number: "A"})

      # 1.305854174453145, 103.85533986268689 #Jalan Besar MRT
      # 1.3039117948260748, 103.85260083492733 #Rochor MRT
      # 1.3032301909161217, 103.85291996616341 #Sim Lim Sq

      carpark_b =
        carpark_fixture(%{
          number: "B",
          latitude: 1.305854174453145,
          longitude: 103.85533986268689,
          available_lots: 10
        })

      carpark_c =
        carpark_fixture(%{
          number: "C",
          latitude: 1.3039117948260748,
          longitude: 103.85260083492733,
          available_lots: 5
        })

      assert [^carpark_c, ^carpark_b] =
               Govt.nearest_available_carparks(%Location{
                 latitude: 1.3032301909161217,
                 longitude: 103.85291996616341
               })
    end

    test "load_availability/0 updates availablity information for carparks mentioned in external data source" do
      carpark = carpark_fixture()

      data = [
        %{
          "carpark_info" => [
            %{
              "lot_type" => "C",
              "lots_available" => "278",
              "total_lots" => "511"
            },
            %{
              "lot_type" => "X",
              "lots_available" => "1",
              "total_lots" => "1"
            }
          ],
          "carpark_number" => "some number",
          "update_datetime" => "2022-01-28T08:54:46"
        }
      ]

      Shopcash.Govt.Http.MockClient
      |> expect(:carpark_availability, fn ->
        data
      end)

      assert :ok = Govt.load_availability()
      carpark = Govt.get_carpark!(carpark.id)
      assert carpark.total_lots == 512
      assert carpark.available_lots == 279
    end

    test "load_carparks/0 loads all file data into database" do
      data = """
      "car_park_no","address","x_coord","y_coord","car_park_type","type_of_parking_system","short_term_parking","free_parking","night_parking","car_park_decks","gantry_height","car_park_basement"
      "ACB","BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK","30314.7936","31490.4942","BASEMENT CAR PARK","ELECTRONIC PARKING","WHOLE DAY","NO","YES","1","1.80","Y"
      "ACM","BLK 98A ALJUNIED CRESCENT","33758.4143","33695.5198","MULTI-STOREY CAR PARK","ELECTRONIC PARKING","WHOLE DAY","SUN & PH FR 7AM-10.30PM","YES","5","2.10","N"
      """

      Shopcash.Govt.Http.MockClient
      |> expect(:svy21_to_wgs84, 2, fn _x_coord, _y_coord ->
        %{"latitude" => 1.23, "longitude" => 4.56}
      end)

      full_path = Path.expand("carpark_info.csv", __DIR__)

      {:ok, file} = File.open(full_path, [:write])

      :ok = IO.binwrite(file, data)
      :ok = File.close(file)

      try do
        assert Govt.list_carparks() == []

        assert Govt.load_carparks(full_path) == :ok

        [first, second] = Govt.list_carparks()

        latitude = 1.23
        longitude = 4.56

        assert %Shopcash.Govt.Carpark{
                 latitude: ^latitude,
                 longitude: ^longitude
               } = first

        assert %Shopcash.Govt.Carpark{
                 latitude: ^latitude,
                 longitude: ^longitude
               } = second
      after
        :ok = File.rm!(full_path)
      end
    end

    test "list_carparks/0 returns all carparks" do
      carpark = carpark_fixture()
      assert Govt.list_carparks() == [carpark]
    end

    test "get_carpark!/1 returns the carpark with given id" do
      carpark = carpark_fixture()
      assert Govt.get_carpark!(carpark.id) == carpark
    end

    test "create_carpark/1 with valid data creates a carpark" do
      valid_attrs = %{
        number: "some number",
        address: "some address",
        latitude: "120.5",
        longitude: "120.5"
      }

      assert {:ok, %Carpark{} = carpark} = Govt.create_carpark(valid_attrs)
      assert carpark.address == "some address"
      assert carpark.latitude == 120.5
      assert carpark.longitude == 120.5
    end

    test "create_carpark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Govt.create_carpark(@invalid_attrs)
    end

    test "update_availability/3 with valid data updates avaiability" do
      carpark = carpark_fixture()
      assert {1, nil} = Govt.update_availability(carpark.number, 20, 10)
      carpark = Govt.get_carpark!(carpark.id)
      assert carpark.total_lots == 20
      assert carpark.available_lots == 10
    end

    test "update_carpark/2 with valid data updates the carpark" do
      carpark = carpark_fixture()
      update_attrs = %{address: "some updated address", latitude: "456.7", longitude: "456.7"}

      assert {:ok, %Carpark{} = carpark} = Govt.update_carpark(carpark, update_attrs)
      assert carpark.address == "some updated address"
      assert carpark.latitude == 456.7
      assert carpark.longitude == 456.7
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
