defmodule Exmock.ChatController do
  use Maru.Router
  use Ezx.Controller
  use Exmock.Common.ErrorCode
  alias Exmock.Service.User, as: UserService


  params do
    requires :uid, type: Integer
    requires :type, type: String
  end
  get "chat" do
    [namespace, api] = String.split(params[:type], ".")
    resp = cond do
      namespace == "user" ->
        route UserService,
              api,
              params
      namespace == "group" ->
        GroupService.handle(api, params)
    end

    conn
    |> put_status(200)
    |> json(fit_for_im_erlang(resp))
    #    |> json((resp))
  end

  defp fit_for_im_erlang(%{service: @ok, data: d}) do
    d
  end
  defp fit_for_im_erlang(_) do
    %{}
  end
end