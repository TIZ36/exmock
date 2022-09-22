defmodule Exmock.Check do
  @moduledoc """
  定义一些exmock里面独有的检查
  """

  @doc """
  返回输入是否可以被顺利的 json encode
  """
  def can_json_encoded?(v) do
    case Jason.encode(v) do
      {:ok, _} ->
        true

      _ ->
        false
    end
  end
end
