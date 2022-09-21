defmodule Exmock.IdUtil do
  @moduledoc false
  def gen_id() do
    {:ok, id} = Snowflake.next_id()
    id
  end
end
