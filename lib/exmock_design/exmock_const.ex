defmodule Exmock.Const do
  defmacro __using__(_opts) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__)

      @resp_code_ok 200
      @resp_code_fail 666
    end
  end
end
