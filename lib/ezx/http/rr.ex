defmodule Ezx.Http.RR do
  @moduledoc """
  本模块用于定义http请求、相应的便利函数和宏
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      use Ezx.Http.Code
    end
  end
end
