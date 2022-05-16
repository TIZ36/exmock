defmodule Exmock.Switcher.Gmock do
  use Exmock.Server

  resources do
    get do
      json(conn, %{ hello: :world })
    end

    mount Exmock.ChatController
  end
end
