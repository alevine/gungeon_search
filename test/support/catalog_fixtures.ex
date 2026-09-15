defmodule GungeonSearch.CatalogFixtures do
  @moduledoc """
  Test helpers for creating guns, items, and synergies via `GungeonSearch.Catalog`.
  """

  alias GungeonSearch.{GunSynergy, ItemSynergy, Repo, Synergy}

  def gun_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "Test Gun #{System.unique_integer([:positive])}",
        quote: "A test quote",
        type: "Semiautomatic",
        image: "https://example.com/gun.png"
      })

    %GungeonSearch.Gun{}
    |> GungeonSearch.Gun.changeset(attrs)
    |> Repo.insert!()
  end

  def item_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "Test Item #{System.unique_integer([:positive])}",
        quote: "A test quote",
        type: "Passive",
        image: "https://example.com/item.png"
      })

    %GungeonSearch.Item{}
    |> GungeonSearch.Item.changeset(attrs)
    |> Repo.insert!()
  end

  def gun_synergy_fixture(gun, attrs \\ %{}) do
    synergy = synergy_fixture(attrs[:synergy] || %{})

    %GunSynergy{}
    |> GunSynergy.changeset(%{
      gun_id: gun.id,
      synergy_id: synergy.id,
      effect: attrs[:effect] || "Test effect"
    })
    |> Repo.insert!()
  end

  def item_synergy_fixture(item, attrs \\ %{}) do
    synergy = synergy_fixture(attrs[:synergy] || %{})

    %ItemSynergy{}
    |> ItemSynergy.changeset(%{
      item_id: item.id,
      synergy_id: synergy.id,
      effect: attrs[:effect] || "Test effect"
    })
    |> Repo.insert!()
  end

  defp synergy_fixture(attrs) do
    n = System.unique_integer([:positive])

    attrs =
      Enum.into(attrs, %{
        name: "Test Synergy #{n}",
        link: "/Synergies#Test_Synergy_#{n}"
      })

    %Synergy{}
    |> Synergy.changeset(attrs)
    |> Repo.insert!()
  end
end
