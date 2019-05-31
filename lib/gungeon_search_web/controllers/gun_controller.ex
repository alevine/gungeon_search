defmodule GungeonSearchWeb.GunController do
  use GungeonSearchWeb, :controller

  alias GungeonSearch.Gun
  alias GungeonSearch.Repo

  def show(conn, params) do
    gun = Repo.get_by(Gun, id: params["id"])
    render(conn, "show.html", gun: gun)
  end
end
