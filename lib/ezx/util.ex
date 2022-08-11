defmodule Ezx.Util do
  defmacro no_panic(api, [fallback: fall_back_return], do: block) do
    quote do
      require Logger

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

  defmacro map_transfer(input) do
    block =
      Macro.prewalk(
        input,
        fn
          {k, v} ->
            {to_string(k), v}
          o ->
            o
        end
      )
    quote do
      unquote(block)
    end
  end

  defmacro update(record, field, value) do
    IO.inspect(record)

    new_record =
      record
      |> Macro.prewalk(
           fn
             {^field, ov} = v ->
               {field, value}
             o ->
               o
           end
         )
    quote do
      unquote(new_record)
    end
  end

end

defmodule Test do
  require Record
  import Ezx.Util
  Record.defrecord(:user, name: "zt", age: 30)
  Record.defrecord(:email, address: "11111@qq.com", host: "qq")

  def email_r(email(address: old_address) = input) do
    Macro.escape(email(input))


  end

  def a(email(address: addr, host: host) = input) do
    email(input, address: "zz")
  end

end