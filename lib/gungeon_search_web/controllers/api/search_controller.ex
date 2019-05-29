defmodule GungeonSearchWeb.SearchController do
  use GungeonSearchWeb, :controller

  alias GungeonSearch.{Item, Gun}

  def show(conn, params) do
    results = Gun.search(params["query"]) ++ Item.search(params["query"])
    render(conn, "show.json", results: results)
  end
end
