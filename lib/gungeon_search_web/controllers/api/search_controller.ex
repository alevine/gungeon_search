defmodule GungeonSearchWeb.SearchController do
  use GungeonSearchWeb, :controller

  alias GungeonSearch.Catalog

  def show(conn, params) do
    json(conn, Catalog.search(params["query"]))
  end
end
