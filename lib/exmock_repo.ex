defmodule Exmock.Repo do
  use Ecto.Repo,
    otp_app: :exmock,
    adapter: Ecto.Adapters.MyXQL
end
