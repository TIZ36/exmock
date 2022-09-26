defmodule Exmock.ChatApi do
  @moduledoc """
  /chat?xx
  chat api汇总
  """

  use Maru.Router
  use Exmock.Resp

  # alias of Service-Logic Layer
  alias Exmock.Service.User, as: UserService
  alias Exmock.Service.Group, as: GroupService

  require Logger


  @doc """
  定义分发的service入口
  """
  # user
  def dispatch_get("user", api, params) do
    no_panic "user.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      full_path = "user.#{api}"
      UserService.get(full_path, params)
    end
  end
  # group
  def dispatch_get("group", api, params) do
    no_panic "group.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      full_path = "group.#{api}"
      GroupService.get(full_path, params)
    end
  end

  def dispatch_post("user", api, params) do
    no_panic "user.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      full_path = "user.#{api}"
      UserService.post(full_path, params)
    end
  end
  def dispatch_post("group", api, params) do
    no_panic "group.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      full_path = "group.#{api}"
      GroupService.post(full_path, params)
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
        |> json((resp))

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

  defp out(%{code: @resp_code_ok, data: data}) do
    data
  end
  defp out(%{}= e) do
    e
  end
  defp out(_) do
    %{}
  end
end
