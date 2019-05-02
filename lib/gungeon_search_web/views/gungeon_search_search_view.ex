defmodule GungeonSearchWeb.SearchView do
  use GungeonSearchWeb, :view

  def render("show.json", %{results: results}) do
    %{data: render_many(results, GungeonSearchWeb.SearchView, "result.json", as: :result)}
  end

  def render("result.json", %{result: result}) do
    Poison.encode!(result)
  end
end
