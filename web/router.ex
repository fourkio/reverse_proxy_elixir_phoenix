defmodule ReverseProxy.Router do
  use ReverseProxy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReverseProxy do
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "v1", ReverseProxy do
    pipe_through :api
  end

  scope "api", ReverseProxy do
    pipe_through :api
  end

end
