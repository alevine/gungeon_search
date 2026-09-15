defmodule GungeonSearchWeb.SearchControllerTest do
  use GungeonSearchWeb.ConnCase, async: true

  import GungeonSearch.CatalogFixtures

  test "GET /api/search/:query returns matching guns and items as JSON", %{conn: conn} do
    gun = gun_fixture(name: "Pea Shooter")

    conn = get(conn, ~p"/api/search/pea")

    assert [%{"id" => id, "name" => "Pea Shooter", "type" => "gun"}] = json_response(conn, 200)
    assert id == gun.id
  end

  test "GET /api/search/:query returns an empty array for no matches", %{conn: conn} do
    conn = get(conn, ~p"/api/search/zzzzznomatch")

    assert json_response(conn, 200) == []
  end
end
