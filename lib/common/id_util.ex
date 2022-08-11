defmodule Exmock.IdUtil do
  def gen_id() do
    {:ok, id} = Snowflake.next_id()
    id
  end
end