defmodule Test do

  use Exmock.Resp

  def okr(r) do
    ok(data: r)
  end

  def failr(r) do
    fail(r)
  end

  def failr2() do
    fail(@unknown_err)
  end
end
