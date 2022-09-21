defmodule Exmock.Switcher.Gmock do
  @moduledoc """
  根路由器，转发请求到业务层处理
  """
  use Exmock.Server
  require Logger

  resources do
    get do
      json(conn, %{hello: :world})
    end

    mount(Exmock.ChatApi)
  end

  rescue_from :all, as: e do
    Logger.error("#{inspect(e)}")

    conn
    |> put_status(500)
    |> text("Run time error")
  end
end
