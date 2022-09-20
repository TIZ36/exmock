defmodule Exmock.EtsCache do
  use Nebulex.Cache,
    otp_app: :exmock,
    adapter: Nebulex.Adapters.Local
end
