defmodule Exmock.RedisCache do
  @moduledoc """
  Nebulex RedisCache
  """
  use Nebulex.Cache,
      otp_app: :exmock,
      adapter: NebulexRedisAdapter
end
