defmodule Exmock.HttpClient do
  @moduledoc """
  http client工具类：
    1、使用tesla+finch的组合
  """
  def init() do
    Finch.start_link(name: ImFinch, pools: %{default: [size: 10]})
  end

  defp common_middleware() do
    [
      Tesla.Middleware.EncodeJson,
      Tesla.Middleware.HeaderTransfer
    ]
  end

  @doc """
  http get请求
  """
  def http_get(url, timeout \\ 5000, headers \\ [], opts \\ [])

  def http_get(url, timeout, headers, opts) when is_integer(timeout) and is_list(url) do
    http_get(to_string(url), timeout, headers, opts)
  end

  def http_get(url, timeout, headers, opts) when is_integer(timeout) and is_binary(url) do
    timeout = round(timeout * 0.7)
    middleware_headers = {Tesla.Middleware.Headers, headers}
    middleware_opts = {Tesla.Middleware.Opts, opts}

    case Tesla.client(
           [middleware_headers, middleware_opts] ++ common_middleware(),
           {
             Tesla.Adapter.Finch,
             name: ImFinch, pool_timeout: 1_500, receive_timeout: timeout
           }
         )
         |> Tesla.get(url) do
      {:ok, %Tesla.Env{status: code, headers: headers, body: body}} ->
        {:ok, %{code: code, body: body, headers: headers}}

      {:error, _reason} = ret ->
        ret
    end
  end

  @doc """
  http post请求
  """
  def http_post(url, body, timeout \\ 5000, headers \\ [], opts \\ [])

  def http_post(url, body, timeout, headers, opts) when is_integer(timeout) and is_list(url) do
    http_post(to_string(url), body, timeout, headers, opts)
  end

  def http_post(url, body, timeout, headers, opts) when is_integer(timeout) and is_binary(url) do
    timeout = round(timeout * 0.7)

    middleware_headers = {Tesla.Middleware.Headers, headers}
    middleware_opts = {Tesla.Middleware.Opts, opts}

    case Tesla.client(
           [middleware_headers, middleware_opts] ++ common_middleware(),
           {
             Tesla.Adapter.Finch,
             name: ImFinch, pool_timeout: 1_500, receive_timeout: timeout
           }
         )
         |> Tesla.post(url, body) do
      {:ok, %Tesla.Env{status: code, headers: headers, body: body}} ->
        {:ok, %{code: code, body: body, headers: headers}}

      {:error, _reason} = ret ->
        ret
    end
  end

  def http_head(url, timeout \\ 5000, opts \\ []) when is_integer(timeout) do
    timeout = round(timeout * 0.7)
    middleware_opts = {Tesla.Middleware.Opts, opts}

    case Tesla.client(
           [middleware_opts | common_middleware()],
           {
             Tesla.Adapter.Finch,
             name: ImFinch, pool_timeout: 1_500, receive_timeout: timeout
           }
         )
         |> Tesla.head(url) do
      {:ok, %Tesla.Env{status: code, headers: headers, body: body}} ->
        {:ok, %{code: code, body: body, headers: headers}}

      {:error, _reason} = ret ->
        ret
    end
  end
end
