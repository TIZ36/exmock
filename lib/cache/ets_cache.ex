defmodule Exmock.EtsCache do
  @moduledoc false
  use Nebulex.Cache,
    otp_app: :exmock,
    adapter: Nebulex.Adapters.Local
end
