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

  defmacro service_route(module, service_name, params) do
    quote do
      IO.inspect("before service")
      IO.inspect("do service")
      re = apply(unquote(module), :service, [unquote(service_name), unquote(params)])
      IO.inspect("after service")
      re
    end
  end
end