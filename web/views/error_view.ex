defmodule ReverseProxy.ErrorView do
  use ReverseProxy.Web, :view

  def render("404.json", assigns) do
    conn = assigns[:conn]
    params = conn.query_string
    host = "http://api.pocketconf.com"
    url = host <> conn.request_path <> "?" <> params
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode(body) do
          {:error, _} ->
            %{status: 500, message: "Remote Bad Response"}
          {:ok, response} ->
            response
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %{status: 404, message: "Remote Not Found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        %{status: 500, message: "Remote Server Error"}
    end
  end

  def render("500.json", _assigns) do
    %{status: 500, message: "Internal Server Error"}
  end

  def render("404.html", _assigns) do
    "Not Found"
  end

  def render("500.html", _assigns) do
    "Internal Server Error"
  end

end
