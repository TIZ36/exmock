defmodule Exmock.RedisCache do
  use Nebulex.Cache,
      otp_app: :exmock,
      adapter: NebulexRedisAdapter
end