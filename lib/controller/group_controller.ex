defmodule Exmock.GroupController do
  use Maru.Router
  use Ezx.Controller
  use Exmock.Common.ErrorCode
  use Exmock.IMConstants

  get "ping" do
    conn
    |> text("pong")
  end

  params do
    requires :group_name, type: String
    requires :group_avatar, type: String, default: Exmock.Defaults.avatar()
    requires :group_type, type: Integer, values: [1, 4]
    optional :group_sub_type, type: Integer
  end
  post "create" do
    bo =
      params
      |> Exmock.Service.Group.toBo(service: "create")
    re_dto = route Exmock.Service.Group, "group.create", bo

    conn
    |> json(re_dto)
  end

  post "update" do

  end

  post "add_mem" do

  end

  post "remove_mem" do

  end

  get "info" do

  end

  get "members" do

  end
end