defmodule Exmock.Switcher.Gmock do
  use Exmock.Server

  resources do
    get do
      json(conn, %{ hello: :world })
    end

    namespace "group" do
      mount Exmock.GroupController
    end

    mount Exmock.ChatController
  end

  rescue_from :all, as: e do
    e |> IO.inspect

    conn
    |> put_status(500)
    |> text("Run time error")
  end
end
