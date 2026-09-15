defmodule GungeonSearchWeb.GunController do
  use GungeonSearchWeb, :controller

  alias GungeonSearch.Catalog

  def show(conn, params) do
    gun = Catalog.get_gun!(params["id"])
    render(conn, "show.html", gun: gun, synergies: Catalog.synergies_for(gun))
  end
end
