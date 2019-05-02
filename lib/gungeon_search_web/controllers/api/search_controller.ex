defmodule GungeonSearchWeb.SearchController do
  use GungeonSearchWeb, :controller

  alias GungeonSearch.{Item, Gun, Repo}

  def show(conn, _params) do
    results = Gun.search(_params["query"]) ++ Item.search(_params["query"])
    render(conn, "show.json", results: results)
  end
end
