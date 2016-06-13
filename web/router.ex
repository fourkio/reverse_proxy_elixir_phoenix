defmodule ReverseProxy.Router do
  use ReverseProxy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReverseProxy do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # When you add your current production API route-by-route
  # This is where you will setup the Phoenix API to handle it
  # scope "/api", ReverseProxy do
  #   pipe_through :api
  # end
end
