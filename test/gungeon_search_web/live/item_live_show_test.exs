defmodule GungeonSearchWeb.ItemLive.ShowTest do
  use GungeonSearchWeb.ConnCase, async: true

  import GungeonSearch.CatalogFixtures

  test "renders the item's details and synergies", %{conn: conn} do
    item = item_fixture(name: "Meatbun", effect: "Heals one heart.")
    item_synergy_fixture(item, synergy: %{name: "Sausage and Pepper"}, effect: "Heals more.")

    {:ok, _view, html} = live(conn, ~p"/item/#{item.id}")

    assert html =~ "Meatbun"
    assert html =~ "Heals one heart."
    assert html =~ "Sausage and Pepper"
    assert html =~ "Heals more."
  end

  test "raises Ecto.NoResultsError for an unknown id", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/item/0") end
  end
end
