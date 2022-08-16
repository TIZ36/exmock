defmodule Ezx.Common.Norm do
  @moduledoc """
  提供通用功能的模块
  """
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro code(code, msg: msg) do
    quote do
      %{
        code: unquote(code),
        msg: unquote(msg)
      }
    end
  end
end
