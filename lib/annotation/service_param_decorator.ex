defmodule ServiceParamsDecorator do
  use Decorator.Define, [trans: 2]

  def trans(params, type_define, body, context) do
    quote do
      td = unquote(type_define)
      keys = :proplists.get_keys(td)
      pp =
        unquote(params)
        |> Map.take(keys)
        |> Enum.map(fn {k, v} ->
          type = :proplists.get_value(k, td)
          to_type_mod = %{
                          Integer: ToIntegerProtocol,
                          String: ToStringProtocol,
                          Float: ToFloatProtocol
                        } |> Map.get(type)

          {k, to_type_mod.to(v)}
        end)
        |> :maps.from_list()

      var!(params) = pp
      unquote(body)
    end
  end
end