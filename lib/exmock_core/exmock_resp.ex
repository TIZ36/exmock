defmodule Exmock.Resp do
  defmacro __using__(_opts) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__)

      use Exmock.ErrorCode
      use Exmock.Const

      import Exmock.Guards

      def resp(code, data) do
        if code == @resp_code_ok do
          %{
            code: code,
            msg: "success",
            data: data
          }
        else
          %{
            code: code,
            msg: data,
            data: %{}
          }
        end
      end

      @doc """
      成功的返回
      这里的data一定要是可以 Json encoded的类型
      """
      def ok(data: data) do
        if Exmock.Check.can_json_encoded?(data) do
          resp(@resp_code_ok, data)
        else
          throw({:error, "invalid data when attempt resp, data: #{inspect(data)}"})
        end
      end

      @doc """
      失败
      """
      # 没有具体的错误码，错误信息
      def fail(msg) when is_binary(msg) do
        resp(@resp_code_fail, msg)
      end
      # 有具体的错误码，错误信息
      def fail(%{code: code, err_msg: msg} = ecode) when is_map(ecode) do
        resp(code, msg)
      end
    end
  end
end
