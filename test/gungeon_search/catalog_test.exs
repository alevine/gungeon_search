defmodule GungeonSearch.CatalogTest do
  use GungeonSearch.DataCase, async: true

  import GungeonSearch.CatalogFixtures

  alias GungeonSearch.Catalog

  describe "search/1" do
    test "matches on substring, case-insensitively" do
      gun = gun_fixture(name: "Pea Shooter")

      assert [%{id: id, type: "gun", name: "Pea Shooter"}] = Catalog.search("PEA")
      assert id == gun.id
    end

    test "matches guns and items together, ranking the closer match first" do
      exact = gun_fixture(name: "Casey")
      fuzzy = item_fixture(name: "Case Reader")

      results = Catalog.search("Casey")
      ids = Enum.map(results, & &1.id)

      assert exact.id in ids
      assert fuzzy.id in ids
      assert List.first(results).id == exact.id
    end

    test "returns an empty list for a blank query" do
      assert Catalog.search("") == []
      assert Catalog.search("   ") == []
      assert Catalog.search(nil) == []
    end

    test "returns an empty list when nothing matches" do
      gun_fixture(name: "Casey")
      assert Catalog.search("zzzzznomatch") == []
    end
  end

  describe "get_gun!/1 and synergies_for/1" do
    test "preloads synergies sorted by name" do
      gun = gun_fixture(name: "Pea Shooter")
      gun_synergy_fixture(gun, synergy: %{name: "Zeta Synergy"}, effect: "second")
      gun_synergy_fixture(gun, synergy: %{name: "Alpha Synergy"}, effect: "first")

      loaded = Catalog.get_gun!(gun.id)

      assert [
               %{name: "Alpha Synergy", effect: "first"},
               %{name: "Zeta Synergy", effect: "second"}
             ] = Catalog.synergies_for(loaded)
    end
  end

  describe "get_item!/1 and synergies_for/1" do
    test "preloads synergies" do
      item = item_fixture(name: "Meatbun")
      item_synergy_fixture(item, synergy: %{name: "Sausage and Pepper"}, effect: "heals more")

      loaded = Catalog.get_item!(item.id)

      assert [%{name: "Sausage and Pepper", effect: "heals more"}] =
               Catalog.synergies_for(loaded)
    end
  end
end
