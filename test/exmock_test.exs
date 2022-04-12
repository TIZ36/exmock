defmodule ExmockTest do
  use ExUnit.Case
  doctest Exmock

  test "greets the world" do
    assert Exmock.hello() == :world
  end
end
