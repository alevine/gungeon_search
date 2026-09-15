defmodule GungeonSearchWeb.Router do
  use GungeonSearchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GungeonSearchWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GungeonSearchWeb do
    pipe_through :browser

    live_session :default do
      live "/", HomeLive
      live "/gun/:id", GunLive.Show
      live "/item/:id", ItemLive.Show
    end
  end

  scope "/api", GungeonSearchWeb do
    pipe_through :api

    get "/search/:query", SearchController, :show
  end
end
