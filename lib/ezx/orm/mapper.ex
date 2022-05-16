defmodule Ezx.Orm.Mapper do
  @moduledoc """
  macros for mapper
  """

  @callback validate(struct, fun) :: true | false

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro mapper(mapper_name, [validator: func, po: po_type], do: block) when is_binary(mapper_name) do
    func_name = String.to_atom(mapper_name)
    quote do
      def unquote(func_name)(unquote(po_type) = input) do
        case unquote(func).(input) do
          true ->
            unquote(block)
          false ->
            {:fail, "validate fail"}
        end
      end
    end
  end
end