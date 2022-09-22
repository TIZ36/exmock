defmodule BubbleConfig do
  @moduledoc false
  @derive Jason.Encoder
  defstruct url: "", edge_insets: [5, 5, 5, 5]
end
