defmodule Exmock.ChatApi do
  use Maru.Router
  use Exmock.Common.ErrorCode
  alias Exmock.Service.User, as: UserService

  require Ezx.Util
  require Logger

  @doc """
  定义分发的service入口
  """
  def dispatch_get("user", api, params) do
    Ezx.Util.no_panic "user.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      UserService.get(api, params)
    end
  end

  get "chat" do
    case fetch_params(conn) do
      %{"type" => type} = params ->
        Logger.info(conn)
        [field, api] = String.split(type, ".")

        # 获取业务层的返回结果
        resp = dispatch_get(field, api, params)

        conn
        |> put_status(200)
        |> json(out(resp))
      _ ->
        conn
        |> put_status(400)
        |> json(%{})
    end
  end

  defp fetch_params(%Plug.Conn{params: params}) do
    params
  end

  defp out(%{service: @ok, data: d}) do
    d
  end
  defp out(_) do
    %{}
  end
end