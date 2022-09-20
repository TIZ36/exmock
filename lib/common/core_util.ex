defmodule Exmock.Core.Util do
  import Ezx.Util

  def type_ok?(k, t) do
    t == type(k)
  end

  def type(k) do
    IEx.Info.info(k)
    |> :maps.from_list()
    |> Map.get("Data type")
    |> String.to_atom()
  end

  def to_type(v, :Integer) do

  end
  def to_type(v, :BitString) do

  end

  defmodule Test do
    def dd() do
      a = [1,2,3]
      Enum.reduce_while(a, [], fn v, acc ->
        if rem(v, 2) == 0 do
          {:cont, acc}
        else
          {:cont, [v | acc]}
        end
      end)
    end
  end
end