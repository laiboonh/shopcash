defmodule ShopcashWeb.CarparkControllerTest do
  use ShopcashWeb.ConnCase

  import Shopcash.GovtFixtures

  alias Shopcash.Govt.Carpark

  @create_attrs %{
    number: "some number",
    address: "some address",
    latitude: "120.5",
    longitude: "120.5"
  }
  @update_attrs %{
    number: "some updated number",
    address: "some updated address",
    latitude: "456.7",
    longitude: "456.7"
  }
  @invalid_attrs %{number: nil, address: nil, latitude: nil, longitude: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "nearest" do
    test "when required params latitude or longitude are not given", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.carpark_path(conn, :nearest)
        )

      assert json_response(conn, 400) ==
               %{"message" => "latitude: can't be blank\nlongitude: can't be blank"}
    end

    test "list all nearest available carparks", %{conn: conn} do
      carpark_a = Enum.into(%{number: "A"}, @create_attrs)

      carpark_b =
        Enum.into(
          %{
            number: "B",
            latitude: "1.305854174453145",
            longitude: "103.85533986268689",
            available_lots: "10",
            total_lots: "20"
          },
          @create_attrs
        )

      carpark_c =
        Enum.into(
          %{
            number: "C",
            latitude: "1.3039117948260748",
            longitude: "103.85260083492733",
            available_lots: "5",
            total_lots: "10"
          },
          @create_attrs
        )

      conn = post(conn, Routes.carpark_path(conn, :create), carpark: carpark_a)
      conn = post(conn, Routes.carpark_path(conn, :create), carpark: carpark_b)
      conn = post(conn, Routes.carpark_path(conn, :create), carpark: carpark_c)

      conn =
        get(
          conn,
          Routes.carpark_path(conn, :nearest,
            latitude: 1.3032301909161217,
            longitude: 103.85291996616341
          )
        )

      assert json_response(conn, 200) == [
               %{
                 "address" => "some address",
                 "available_lots" => 5,
                 "latitude" => 1.3039117948260748,
                 "longitude" => 103.85260083492733,
                 "total_lots" => 10
               },
               %{
                 "address" => "some address",
                 "available_lots" => 10,
                 "latitude" => 1.305854174453145,
                 "longitude" => 103.85533986268689,
                 "total_lots" => 20
               }
             ]
    end
  end

  describe "index" do
    test "lists all carparks", %{conn: conn} do
      conn = get(conn, Routes.carpark_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create carpark" do
    test "renders carpark when data is valid", %{conn: conn} do
      conn = post(conn, Routes.carpark_path(conn, :create), carpark: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.carpark_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "number" => "some number",
               "address" => "some address",
               "latitude" => 120.5,
               "longitude" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.carpark_path(conn, :create), carpark: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update carpark" do
    setup [:create_carpark]

    test "renders carpark when data is valid", %{conn: conn, carpark: %Carpark{id: id} = carpark} do
      conn = put(conn, Routes.carpark_path(conn, :update, carpark), carpark: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.carpark_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "number" => "some updated number",
               "address" => "some updated address",
               "latitude" => 456.7,
               "longitude" => 456.7
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, carpark: carpark} do
      conn = put(conn, Routes.carpark_path(conn, :update, carpark), carpark: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete carpark" do
    setup [:create_carpark]

    test "deletes chosen carpark", %{conn: conn, carpark: carpark} do
      conn = delete(conn, Routes.carpark_path(conn, :delete, carpark))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.carpark_path(conn, :show, carpark))
      end
    end
  end

  defp create_carpark(_) do
    carpark = carpark_fixture()
    %{carpark: carpark}
  end
end
