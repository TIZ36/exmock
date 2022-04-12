defmodule Exmock.Api.User do
  use Exmock.Server

  namespace :user do
    route_param :id do
      get do
        json(conn, %{user: params[:id]})
      end
    end
  end
end
