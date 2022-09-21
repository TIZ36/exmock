defmodule Exmock.Service.Group do
  @moduledoc """
  群组业务相关
  """
  use Exmock.Common.ErrorCode
  use Ezx.Service
  use ServiceParamsDecorator

  require Logger

  alias Exmock.Data.Group
  alias Exmock.Data.User
  alias Exmock.Data.UserGroup
  alias Exmock.Data.Schema.GroupInfo

  import Ezx.Util

  @doc """
  GET / group
  """
  def get(api, params)

  @decorate trans(params, [{"groupId", :Integer}, {"language", :String}])
  def get("info", params) do
    gid = params["groupId"]

    case Group.query_group_info_by_gid(gid) do
      nil ->
        fail(@ecode_not_found)

      {:fail, _reason} ->
        fail(@ecode_db_error)

      %GroupInfo{} = group_info_struct ->
        group_info_map =
          group_info_struct
          |> DTA.TransProtocol.trans()

        ok(data: group_info_map)
    end
  end

  @decorate trans(params, [{"groupId", :Integer}, {"lanaguage", :String}])
  def get("users", params) do
    no_panic "group.users", fallback: fail(@unknown_err), use_throw: true do
      gid = params["groupId"]

      uids = UserGroup.query_group_users(gid)

      group_user_info_list =
        Enum.reduce(uids, [], fn uid, acc ->
          case User.query_user_info_by_id(uid) do
            %Exmock.Data.Schema.UserInfo{} = user_info ->
              [
                DTA.TransProtocol.trans(user_info)
                |> Map.take([:uid, :user_name, :avatar, :guild_name, :kingdom_icon])
                |> Map.merge(%{guild_name: "", kingdom_icon: ""})
                | acc
              ]

            _ ->
              throw(fail(@ecode_not_found))
          end
        end)

      ok(data: group_user_info_list)
    end
  end

  @decorate trans(params, [{"groupId", :Integer}])
  def get("config", params) do
    no_panic "group.config", fallback: fail(@unknown_err) do
      case Group.query_group_config(params["groupId"]) do
        [] ->
          ok(data: [])
        %Exmock.Data.Schema.GroupConfig{} = group_config ->
          data = DTA.TransProtocol.trans(group_config)

          ok(data: data)
        _ ->
          fail(@ecode_db_error)
      end
    end
  end

  @doc """
  用于创建群组
  """
  def post("create", %{"group_name" => gname} = params) do
    group_sub_type = Map.get(params, "group_sub_type", 0)
    group_info_attrs = Exmock.Gen.GroupInfo.gen_group_info(gname, group_sub_type)

    case Group.create_new_group_info(group_info_attrs) do
      {:ok, %GroupInfo{} = re} ->
        group_info_map =
          re
          |> DTA.TransProtocol.trans()

        # 创建成功
        ok(data: group_info_map)

      _ ->
        fail(@ecode_db_error)
    end
  end

  @decorate trans(param, [{"group_id", :Integer}, {"uid", :Integer}])
  def post("user_join", param) do
    no_panic "user_join", fallback: fail(@ecode_not_found), use_throw: true do
      gid = param["group_id"]
      uid = param["uid"]

      # ensure we have this group
      Group.query_group_info_by_gid(gid)

      # ensure we have this user
      User.query_user_info_by_id(uid)

      UserGroup.user_join(gid, uid)

      # notify im server
      Exmock.Service.IMNotify.change_members_v2(0, %{add: [{gid, [uid]}]})

      ok(data: %{code: 200, msg: "success"})
    end
  end

end
