defmodule Exmock.ChatController do
  use Maru.Router
  use ErrorCode
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
    |> json(success(resp))
  end

  defp success({:ok, data}) do
    resp
    |> Map.put(:code, 200)
    |> Map.put_new(:data, %{})
  end
  defp success(_) do
    @unknown_err
    |> Map.merge(%{code: 200, data: %{}})
  end
end