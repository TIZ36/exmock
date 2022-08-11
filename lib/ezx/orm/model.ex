defmodule Ezx.Orm.Model do
  @moduledoc """
  macro for model
  """
  defmacro __using__(_opt) do
    quote do
      use Ecto.Schema
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :data_po, accumulate: true)
      @before_compile unquote(__MODULE__)
      @primary_key false
    end
  end

  @doc """
  maintain some before0-compiling-time variables
  """
  defmacro __before_compile__(_opts) do
    quote do
    end
  end

  @doc """
  a useful macro based on ecto schema to define your `po` model
  """
  defmacro model(model_name, [{:fields, fields} | _others], abs_struct \\ nil) do
    quote do
      real_name =
        String.split("#{unquote(model_name)}", ".")
        |> List.last()
      table_name =
        String.split("#{unquote(model_name)}", ".")
        |> List.last()
      po_model =
        "#{__MODULE__}.#{real_name}"
        |> String.to_atom()


      defmodule po_model do
        use Ecto.Schema
        @table Macro.underscore(table_name)
        @data_po po_model

        @primary_key false
        schema Macro.underscore(table_name), do: unquote(fields)

        def table() do
          @table
        end

        def data_type() do
          unquote(abs_struct)
        end
      end
    end
  end
end