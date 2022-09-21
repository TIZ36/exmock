defmodule Exmock.ChatApi do
  @moduledoc """
  /chat?xx
  chat api汇总
  """

  use Maru.Router
  use Exmock.Common.ErrorCode
  alias Exmock.Service.User, as: UserService
  alias Exmock.Service.Group, as: GroupService

  import Ezx.Util
  require Logger

  @doc """
  定义分发的service入口
  """
  # user
  def dispatch_get("user", api, params) do
    no_panic "user.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      UserService.get(api, params)
    end
  end
  # group
  def dispatch_get("group", api, params) do
    no_panic "group.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      GroupService.get(api, params)
    end
  end

  def dispatch_post("user", api, params) do
    no_panic "user.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      UserService.post(api, params)
    end
  end
  def dispatch_post("group", api, params) do
    no_panic "group.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      GroupService.post(api, params)
    end
  end

  post "chat" do
    case fetch_params(conn) do
      %{"type" => type} = params ->
        [field, api] = String.split(type, ".")

        # 获取业务层的返回结果
        resp = dispatch_post(field, api, params)

        conn
        |> put_status(200)
        |> json(out(resp))

      _ ->
        conn
        |> put_status(400)
        |> json(%{})
    end
  end

  get "chat" do
    case fetch_params(conn) do
      %{"type" => type} = params ->
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
  defp out(%{service: err, data: d}) do
    err
  end
  defp out(_) do
    %{}
  end
end
