defmodule Exmock.NPR do
  @moduledoc """
  Normalize Policy Routines
  """
  @doc """
  检查类型
  """
  def type_ok?(k, t) do
    t == type(k)
  end

  @doc """
  获取类型
  """
  def type(k) do
    IEx.Info.info(k)
    |> :maps.from_list()
    |> Map.get("Data type")
    |> String.to_atom()
  end

  @doc """
  ecode macro
  """
  defmacro ecode(v) do
    quote do
      %{
        unquote_splicing(v)
      }
    end
  end

  defmacro no_panic(api, [{:fallback, fall_back_return} | opts], do: block) do
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

  @doc """
  三元执行函数
  """
  def either_do(input, condition, fun_true, func_false \\ &(&1)) do
    if condition do
      input
      |> fun_true.()
    else
      input
      |> func_false.()
    end
  end
end
