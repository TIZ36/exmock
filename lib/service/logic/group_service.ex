defmodule Exmock.Service.Group do
  @moduledoc """
  群组业务相关
  """

  use Exmock.Resp
  use ServiceParamsDecorator

  require Logger

  # alias of Data-Control Layer
  alias Exmock.Data.Group
  alias Exmock.Data.User
  alias Exmock.Data.UserGroup

  # alias of Data-Schema Layer
  alias Exmock.Data.Schema.GroupInfo

  @doc """
  GET / group
  """
  def get(_api, _params)

  @decorate trans(params, [{"page", :Integer}, {"page_size", :Integer}])
  def get("group.list", params) do
    no_panic "group.list", fallback: [] do
      page = max(params["page"] - 1, 0)
      page_size = params["page_size"]
      groups = Group.query_all_groups(page, page_size)
      ok(data: groups)
    end
  end

  @decorate trans(params, [{"groupId", :Integer}, {"language", :String}])
  def get("group.info", params) do
    no_panic "group_info", fallback: fail(@ecode_service_reject) do
      gid = params["groupId"]

      case Group.query_group_info_by_gid(gid) do
        nil ->
          fail(@ecode_not_found)

        {:fail, _reason} ->
          fail(@ecode_db_error)

        %GroupInfo{} = group_info_struct ->
          group_info_map =
            group_info_struct
            |> DataType.TransProtocol.trans_out()

          ok(data: group_info_map)
      end
    end
  end

  @decorate trans(params, [{"groupId", :Integer}, {"lanaguage", :String}])
  def get("group.users", params) do
    no_panic "group.users", fallback: fail(@unknown_err), use_throw: true do
      gid = params["groupId"]

      uids = UserGroup.query_group_users(gid)

      group_user_info_list =
        Enum.reduce(uids, [], fn uid, acc ->
          case User.query_user_info_by_id(uid) do
            %Exmock.Data.Schema.UserInfo{} = user_info ->
              [
                DataType.TransProtocol.trans_out(user_info)
                |> Map.take([:uid, :user_name, :avatar, :guild_name, :kingdom_icon])
                |> Map.merge(%{guild_name: "", kingdom_icon: ""})
                | acc
              ]

            _ ->
              throw(fail(@ecode_not_found))
          end
        end)

      # im-erlang 特殊的解析规则
      ok(data: %{"list" => group_user_info_list})
    end
  end

  @decorate trans(params, [{"groupId", :Integer}])
  def get("group.config", params) do
    no_panic "group.config", fallback: fail(@unknown_err) do
      case Group.query_group_config(params["groupId"]) do
        [] ->
          ok(data: [])

        %Exmock.Data.Schema.GroupConfig{} = group_config ->
          data = DataType.TransProtocol.trans_out(group_config)

          ok(data: data)

        _ ->
          fail(@ecode_db_error)
      end
    end
  end

  @doc """
  用于创建群组
  """
  @decorate trans(params, [{"group_name", :String}, {"group_sub_type", :Integer}])
  def post("group.create", params) do
    group_sub_type = Map.get(params, "group_sub_type", 0)
    gname = Map.get(params, "group_name", Faker.Company.name())
    group_info_attrs = Exmock.AutoGen.Guilds.create_group(gname, group_sub_type)

    case Group.create_new_group_info(group_info_attrs) do
      {:ok, %GroupInfo{} = re} ->
        group_info_map =
          re
          |> DataType.TransProtocol.trans_out()

        # 创建成功
        ok(data: group_info_map)

      _ ->
        fail(@ecode_db_error)
    end
  end

  @decorate trans(param, [{"group_id", :Integer}, {"uid", :Integer}, {"ope", :Integer}])
  def post("group.join", param) do
    no_panic "join", fallback: fail(@ecode_service_reject) do
      gid = param["group_id"]
      uid = param["uid"]
      ope = Map.get(param, "ope", 0)

      # ensure we have this group
      Group.query_group_info_by_gid(gid)

      # ensure we have this user
      User.query_user_info_by_id(uid)

      UserGroup.user_join(gid, uid)

      IO.inspect("prepare to notify im")

      # notify im server
      Exmock.Service.IMNotify.change_members_v2(ope, %{add: [{gid, [uid]}], leave: []})

      ok(data: %{})
    end
  end

  @decorate trans(params, [{"group_id", :Integer}, {"uid", :Integer}, {"ope", :Integer}])
  def post("group.leave", params) do
    no_panic "group.leave", fallback: fail(@ecode_service_reject) do
      uid = params["uid"]
      gid = params["group_id"]
      ope = Map.get(params, "ope", 0)

      UserGroup.del_user_group_mapping(gid, uid)

      # notify im server
      Exmock.Service.IMNotify.change_members_v2(ope, %{add: [], leave: [{gid, [uid]}]})

      ok(data: %{})
    end
  end
end
