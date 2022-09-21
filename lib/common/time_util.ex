defmodule Exmock.TimeUtil do
  @moduledoc false
  def now_sec() do
    :erlang.system_time(1)
  end

  def now_milli_sec() do
    :erlang.system_time(1000)
  end

  def sec_to_date(sec) do
    DateTime.from_unix!(sec, :second)
  end

  def sec_to_date_str(sec) do
    sec
    |> sec_to_date()
    |> to_string()
  end
end
