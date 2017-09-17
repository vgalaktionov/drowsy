defmodule DrowsyWeb.PageController do
  use DrowsyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
