defmodule GungeonSearchWeb.GunLive.ShowTest do
  use GungeonSearchWeb.ConnCase, async: true

  import GungeonSearch.CatalogFixtures

  test "renders the gun's details and synergies", %{conn: conn} do
    gun = gun_fixture(name: "Pea Shooter", notes: "Fires peas.")
    gun_synergy_fixture(gun, synergy: %{name: "Pea Cannon"}, effect: "Explosive peas.")

    {:ok, _view, html} = live(conn, ~p"/gun/#{gun.id}")

    assert html =~ "Pea Shooter"
    assert html =~ "Fires peas."
    assert html =~ "Pea Cannon"
    assert html =~ "Explosive peas."
  end

  test "raises Ecto.NoResultsError for an unknown id", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/gun/0") end
  end
end
