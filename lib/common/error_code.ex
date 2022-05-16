defmodule ErrorCode do
  defmacro ecode(code, msg: msg) do
    quote do
      %{
        err: %{
          code: unquote(code),
          msg: unquote(msg)
        }
      }
    end
  end
  defmacro __using__(_version) do
    quote do
      import unquote(__MODULE__)

      @unknown_err ecode 999, msg: "unknown err"
      @ecode_not_found ecode 1000, msg: "can not found"

    end
  end
end