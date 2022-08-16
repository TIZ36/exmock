defmodule Ezx.Service do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro service(name, param, do: block) do
    quote do
      def service(unquote(name), unquote(param)) do
        unquote(block)
      end
    end
  end
end
