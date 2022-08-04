defmodule Action.Builder do
  def build_add_on(input, name, age) do
    %{input: input, name: name, age: age}
  end
end
