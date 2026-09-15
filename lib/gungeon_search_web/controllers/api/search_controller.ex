defmodule GungeonSearchWeb.SearchController do
  use GungeonSearchWeb, :controller

  alias GungeonSearch.Catalog

  def show(conn, params) do
    results = Catalog.search(params["query"])
    render(conn, "show.json", results: results)
  end
end
