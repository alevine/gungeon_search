defmodule GungeonSearchWeb.Router do
  use GungeonSearchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GungeonSearchWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/gun/:id", GunController, :show
    get "/item/:id", ItemController, :show
  end

  scope "/api", GungeonSearchWeb do
    pipe_through :api

    get "/search/:query", SearchController, :show
  end
end
