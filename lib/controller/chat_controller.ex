defmodule Exmock.ChatController do
  use Maru.Router

  use Exmock.Common.ErrorCode
  alias Exmock.Service.User, as: UserService


  params do
    requires :uid, type: Integer
    requires :type, type: String
  end
  get "chat" do

    #    IO.inspect(conn)
    IO.inspect(params)
    [namespace, api] = String.split(params[:type], ".")

    resp = cond do
      namespace == "user" ->
        UserService.handle(api, params)
      namespace == "group" ->
        GroupService.handle(api, params)
    end

    IO.inspect(resp)
    conn
    |> put_status(200)
    |> json(resp)
  end
end