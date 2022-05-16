defmodule Ezx.Orm.Model do
  @moduledoc """
  macro for model
  """
  defmacro __using__(_opt) do
    quote do
      use Ecto.Schema
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :data_po, accumulate: false)
      @before_compile unquote(__MODULE__)
      @primary_key false
    end
  end

  @doc """
  maintain some before0-compiling-time variables
  """
  defmacro __before_compile__(_opts) do
    quote do
      def new() do
        %@data_po{}
      end

      def table() do
        @table
      end
    end
  end

  @doc """
  a useful macro based on ecto schema to define your `po` model
  """
  defmacro model(model_name, [{:fields, fields} | _others]) do
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

      @data_po po_model
      @table Macro.underscore(table_name)
      defmodule po_model do
        use Ecto.Schema
        @primary_key false
        schema Macro.underscore(table_name), do: unquote(fields)

        def hi() do
          __MODULE__
        end
      end
    end
  end
end