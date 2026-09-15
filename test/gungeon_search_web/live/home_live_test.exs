defmodule GungeonSearchWeb.HomeLiveTest do
  use GungeonSearchWeb.ConnCase, async: true

  import GungeonSearch.CatalogFixtures

  test "renders the search form", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/")
    assert html =~ "Search the Gungeon"
  end

  test "typing a query shows matching results", %{conn: conn} do
    gun = gun_fixture(name: "Pea Shooter")

    {:ok, view, _html} = live(conn, ~p"/")

    html = render_change(view, "search", %{"query" => "pea"})

    assert html =~ "Pea Shooter"
    assert html =~ ~p"/gun/#{gun.id}"
  end

  test "shows a no-results message when nothing matches", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    html = render_change(view, "search", %{"query" => "zzzzznomatch"})

    assert html =~ "No matches"
  end
end
