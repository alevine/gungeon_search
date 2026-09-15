defmodule GungeonSearchWeb.SearchView do
  use GungeonSearchWeb, :view

  @doc """
  Renders `Catalog.search/1` results (already plain, JSON-encodable maps)
  as a single JSON array - one object per result, not the old
  double-encoded-string-per-item shape.
  """
  def render("show.json", %{results: results}) do
    results
  end
end
