defmodule Guild do
  @moduledoc """
  工会数据结构定义
  """
  @derive Jason.Encoder
  defstruct [:id, :name, :avatar_url, :abbr_name]
end
