defmodule Exmock.Router do
  use Exmock.Server

  require Logger

  before do
    plug(Plug.Logger)
    plug(Plug.Static, at: "/static", from: "/my/static/path/")
  end

  plug(Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Jason,
    parsers: [:urlencoded, :json, :multipart]
  )

  mount(Exmock.Switcher.Gmock)

  rescue_from Unauthorized, as: e do
    Logger.error("#{inspect(e)}")
    conn
    |> put_status(401)
    |> text("Unauthorized")
  end

  rescue_from([MatchError, RuntimeError], with: :custom_error)

  rescue_from :all, as: e do
    conn
    |> put_status(Plug.Exception.status(e))
    |> text("Server Error")
  end

  defp custom_error(conn, exception) do
    conn
    |> put_status(500)
    |> text(exception.message)
  end
end
