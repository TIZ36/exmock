defmodule Tesla.Middleware.HeaderTransfer do
  @moduledoc """
  自定义middleware
    1、将请求里header的charlist都转成string
    2、将响应的header的key转成string，并都改为小写
  """

  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    env
    |> transfer_req_charlist_to_string()
    |> Tesla.run(next)
    |> transfer_resp_header_downcase()
  end

  @doc """
  将请求里header的charlist都转成string
  """
  def transfer_req_charlist_to_string(%Tesla.Env{headers: headers} = env) do
    new_headers = make_header_string(headers, [])
    Map.put(env, :headers, new_headers)
  end
  def transfer_req_charlist_to_string(env) do
    env
  end

  @doc """
  将响应的header的key转成string，并都改为小写
  """
  def transfer_resp_header_downcase(%Tesla.Env{headers: headers} = env) do
    new_headers = make_header_key_downcase(headers, [])
    Map.put(env, :headers, new_headers)
  end
  def transfer_resp_header_downcase(env) do
    env
  end

  # 递归修改 header 的 key 为string，并改为小写
  defp make_header_key_downcase([{k, v} | others], header_transfer) do
    key = String.downcase(to_string(k))

    make_header_key_downcase(others, [{key, v} | header_transfer])
  end
  defp make_header_key_downcase([], header_transfer) do
    header_transfer
  end

  # 递归修改 header 的 key 为string，value是list的时候转为string
  defp make_header_string([{k, v} | others], header_transfer) do
    key = to_string(k)

    value =
      if is_list(v) do
        to_string(v)
      else
        v
      end

    make_header_string(others, [{key, value} | header_transfer])
  end
  defp make_header_string([], header_transfer) do
    header_transfer
  end
end