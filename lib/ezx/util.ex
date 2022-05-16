defmodule Ezx.Util do
  defmacro no_panic(api, [fall_back: fall_back_return], do: block) do
    quote do
      try do
        unquote(block)
      rescue
        err ->
          Logger.warn("rescue err when #{inspect(unquote(api))}, err: #{inspect(err)}")
          unquote(fall_back_return)
      catch
        throws ->
          Logger.warn("catch throw when #{inspect(unquote(api))}, throws: #{inspect(throws)}")
          unquote(fall_back_return)

        :exit, reason ->
          Logger.warn("catch exit when #{inspect(unquote(api))}, reason: #{inspect(reason)}")
          unquote(fall_back_return)
      end
    end
  end
end