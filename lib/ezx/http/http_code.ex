defmodule Ezx.Http.Code do
  @moduledoc """
  定义http code 和 对应的错误信息
  """

  defmacro __using__(_) do
    quote do
      use Ezx.Common.Norm
      import unquote(__MODULE__)

      @code_http_ok code 200, msg: "http resp ok"
      @code_bad_req code 400, msg: "bad request"
      @code_internal_server_err code 500, msg: "internal server error"

      def http_code(http_code_map) do
        http_code_map
        |> Map.get(:code, 500)
      end
      def http_msg(http_code_map) do
        http_code_map
        |> Map.get(:msg, "")
      end
    end
  end
end