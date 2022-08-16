defmodule Kingdom do
  @derive Jason.Encoder
  defstruct [:story_id, :kingdom_id, :avatar_url]
end
