defmodule Exmock.TimeUtil do
  def now_sec() do
    :erlang.system_time(1)
  end
end