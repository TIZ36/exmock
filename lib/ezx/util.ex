defmodule Ezx.Util do
  @moduledoc false
  defmacro no_panic(api, [{fallback, fall_back_return} | opts], do: block) do
    quote do
      require Logger

      use_throw = Keyword.get(unquote(opts), :use_throw, true)

      try do
        unquote(block)
      rescue
        err ->
          Logger.warn("rescue err when #{inspect(unquote(api))}, err: #{inspect(err)}")
          unquote(fall_back_return)
      catch
        :throw, throws ->
          Logger.warn("catch throw when #{inspect(unquote(api))}, throws: #{inspect(throws)}")

          if use_throw do
            throws
          else
            unquote(fall_back_return)
          end

        :exit, reason ->
          Logger.warn("catch exit when #{inspect(unquote(api))}, reason: #{inspect(reason)}")
          unquote(fall_back_return)
      end
    end
  end
end
