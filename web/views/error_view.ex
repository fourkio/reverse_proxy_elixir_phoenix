defmodule ReverseProxy.ErrorView do
  use ReverseProxy.Web, :view

  def render("404.json", assigns) do
    host = "http://api.pocketconf.com"
    conn = assigns[:conn]
    params = conn.query_string
    headers = conn.req_headers
    cookies = [cookie: ["reverse_proxy=true; log_request=false"]]
    url = host <> conn.request_path <> "?" <> params
    case conn.method do
      "GET" ->
        case HTTPoison.get(url, headers, hackney: cookies) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            case Poison.decode(body) do
              {:error, _} ->
                %{status: 500, message: "Remote Bad Response"}
              {:ok, response} ->
                response
            end
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            %{status: 404, message: "Remote Not Found"}
          {:ok, %HTTPoison.Response{status_code: 500}} ->
            %{status: 500, message: "Remote Server Error"}
          {:error, %HTTPoison.Error{}} ->
            %{status: 500, message: "Remote Server Error"}
        end
      "POST" ->
        case HTTPoison.post(url, [], headers, hackney: cookies) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            case Poison.decode(body) do
              {:error, _} ->
                %{status: 500, message: "Remote Bad Response"}
              {:ok, response} ->
                response
            end
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            %{status: 404, message: "Remote Not Found"}
          {:ok, %HTTPoison.Response{status_code: 500}} ->
            %{status: 500, message: "Remote Server Error"}
          {:error, %HTTPoison.Error{}} ->
            %{status: 500, message: "Remote Server Error"}
        end
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
