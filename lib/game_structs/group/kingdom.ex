defmodule Kingdom do
  @moduledoc """
  王国频道的结构题定义
  """
  @derive Jason.Encoder
  defstruct [:story_id, :kingdom_id, :avatar_url]
end
