defmodule ReverseProxy.PageController do
  use ReverseProxy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
