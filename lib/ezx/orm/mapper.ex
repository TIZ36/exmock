defmodule Ezx.Orm.Mapper do
  @moduledoc """
  macros for mapper
  """

  @callback validate(struct, fun) :: true | false

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      require Ezx.Util
      import Ezx.Util

      def no_validate(_po) do
        true
      end
    end
  end

  # mapper with validator func
  defmacro mapper(mapper_name, [validator: func, params: po_type], do: block)
           when is_binary(mapper_name) do
    func_name = String.to_atom(mapper_name)

    quote do
      def unquote(func_name)(unquote(po_type) = input) do
        case unquote(func).(input) do
          true ->
            no_panic unquote(mapper_name), fall_back: {:fail, :db_error} do
              unquote(block)
            end

          false ->
            {:fail, "validate fail"}
        end
      end
    end
  end

  # mapper without validator func
  defmacro mapper(mapper_name, [params: po_type], do: block) when is_binary(mapper_name) do
    quote do
      mapper(
        unquote(mapper_name),
        [validator: &__MODULE__.no_validate/1, params: unquote(po_type)],
        do: unquote(block)
      )
    end
  end
end
