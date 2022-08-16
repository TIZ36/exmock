defmodule Guild do
  @derive Jason.Encoder
  defstruct [:id, :name, :avatar_url, :abbr_name]
end
