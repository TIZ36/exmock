defmodule Exmock.Service.User do
  use Exmock.Common.ErrorCode
  use Ezx.Service
  use ServiceParamsDecorator

  import Ezx.Util

  require Logger

  alias Exmock.Data.User
  alias Exmock.Data.Group
  alias Exmock.Data.UserGroup
  alias Exmock.Data.Schema.GroupInfo

  @doc """
  GET apis, user相关的api获取
  """
  def get(_api, _params)

  @decorate trans(params, [{"uid", :Integer}])
  def get("basicinfo", params) do
    case User.query_user_basicinfo_by_id(params["uid"]) do
      nil ->
        fail(@ecode_not_found)

      {:fail, _reason} ->
        fail(@ecode_db_error)

      %Exmock.Data.Schema.UserBasicInfo{
        cur_stage: cs,
        maincity_level: ml,
        uid: uid
      } ->
        ok(
          data: %{
            cur_stage: cs,
            maincity_level: ml,
            uid: uid
          }
        )
    end
  end

  @decorate trans(params, [{"uid", :Integer}, {"language", :String}])
  def get("info", params) do
    case User.query_user_info_by_id(params["uid"]) do
      nil ->
        fail(@ecode_not_found)

      {:fail, _reason} ->
        fail(@ecode_db_error)

      %Exmock.Data.Schema.UserInfo{} = user_info_schema ->
        re = DTA.TransProtocol.trans(user_info_schema)
        ok(data: re)
    end
  end

  def get("batchInfo", %{"users" => users_url_encoded} = _params) do
    real_users =
      users_url_encoded
      |> URI.decode()
      |> Jason.decode!()

    ids =
      real_users
      |> Enum.map(fn %{"uid" => uid} -> uid end)

    case User.batch_query_user_info_by_ids(ids) do
      {:fail, _reason} ->
        fail(@ecode_db_error)

      re ->
        ok(data: re)
    end
  end

  @decorate trans(params, [{"uid", :Integer}, {"language", :String}])
  def get("groups", params) do
    no_panic "user.groups", fallback: fail(@unknown_err), use_throw: true do
      re = UserGroup.query_user_groups(params["uid"])

      group_info_list =
        Enum.reduce(re, [], fn gid, acc ->
          case Group.query_group_info_by_gid(gid) do
            %GroupInfo{} = group_info_struct ->
              [group_info_struct |> DTA.TransProtocol.trans() | acc]

            _ ->
              throw(fail(@ecode_not_found))
          end
        end)

      ok(data: group_info_list)
    end
  end

  def get("config.infoUI", _params) do
  end

  def get("presence", %{"uids" => uids} = params) do
  end

  @decorate trans(params, [{"uid", :Integer}, {"language", :String}])
  def get("friends", params) do
    no_panic "user.friends", fallback: fail(@unknown_err) do
      re = User.query_user_friends(params["uid"])
      |> Enum.reduce([], fn uid, acc ->
        case User.query_user_info_by_id(uid) do
          %Exmock.Data.Schema.UserInfo{} = user_info_schema ->
            %{avatar: avatar, uid: uid, user_name: user_name} =
              DTA.TransProtocol.trans(user_info_schema)

            [%{id: uid, avatar: avatar, name: user_name} | acc]

          _ ->
            Logger.warn("uid #{uid} cannot find in userinfo")
            acc
        end
      end)

      ok(data: re)
    end
  end

  @decorate trans(params, [{"uid", :Integer}])
  def get("blacklist", params) do
    no_panic "blacklist", fallback: ok(data: []) do
      uid = params["uid"]
      blacklist = User.get_blacklist(uid)
      blackedlist = User.get_blacked_list(uid)

      ok(data: %{blacklist: blacklist, blacklisted: blackedlist})
    end
  end

  # 好友相关
  @doc """
  获取好友请求
  """
  @decorate trans(params, [{"uid", :Integer}])
  def get("friend_reqs", params) do
    no_panic "friend_reqs", fallback: fail(@unknown_err) do
      uids = Exmock.Service.Friend.get_friend_reqs(params["uid"])
      ok(data: uids)
    end
  end

  ### post ###
  def post("create", _params) do
    user_info = AutoGen.UserInfo.new()

    case User.create_user(user_info) do
      {:fail, reason} ->
        fail(@ecode_db_error)

      {:ok,
       %Exmock.Data.Schema.UserInfo{
         data: data_bin,
         uid: uid
       }} ->
        ok(data: :erlang.binary_to_term(data_bin))

      _ ->
        fail(@unknown_err)
    end
  end

  @doc """
  添加好友，user.add_friend
    uid, fid
    -> redis_contains?
    -> is_friend?
    -> Exmock.RedisCache
  """
  @decorate trans(params, [{"from_uid", :Integer}, {"to_uid", :Integer}, {"msg", :String}])
  def post("add_friend", params) do
    no_panic "add_friend", fallback: fail(@unknown_err), use_throw: true do
      from_uid = params["from_uid"]
      to_uid = params["to_uid"]
      msg = params["msg"]

      case Exmock.Service.Friend.add_friend_req(to_uid, from_uid, msg) do
        :ok ->
          ok(data: %{result: "success"})

        _ ->
          fail(@ecode_dup_req)
      end
    end
  end

  @doc """
  接受好友
  """
  @decorate trans(params, [{"uid", :Integer}, {"request_id", :String}])
  def post("accept_friend", params) do
    no_panic "accept_friend", fallback: fail(@unknown_err) do
      uid = params["uid"]
      request_id = params["request_id"]

      case Exmock.Service.Friend.accept_friend_req(uid, request_id) do
        {:ok, _} ->
          ok(data: %{result: "success"})

        {:fail, reason} ->
          Logger.error("#{inspect(reason)}")
          fail(@ecode_service_reject)
      end
    end
  end

  @doc """
  删除好友，user.del_friend
  """
  @decorate trans(params, [{"uid", :Integer}, {"fid", :Integer}])
  def post("del_friend", params) do
    no_panic "user.del_friend", fallback: fail(@unknown_err) do
      uid = params["uid"]
      ano_uid = params["fid"]

      case User.del_friend(%{one_uid: uid, ano_uid: ano_uid}) do
        {:ok, _} ->
          ok(data: %{result: "success"})
        _ ->
          throw(fail(@ecode_db_error))
      end
    end
  end

  @doc """
  添加黑名单
  """
  @decorate trans(params, [{"uid", :Integer}, {"black_uid", :Integer}])
  def post("add_blacklist", params) do
    no_panic "user.add_blacklist", fallblack: fail(@unknown_err) do
      uid = params["uid"]
      black_uid = params["black_uid"]

      User.add_blacklist(uid, black_uid)

      ok(data: %{result: "success"})
    end
  end

  @doc """
  删除黑名单
  """
  @decorate trans(params, [{"uid", :Integer}, {"black_uid", :Integer}])
  def post("del_blacklist", params) do
    no_panic "user.del_blacklist", fallblack: fail(@unknown_err) do
      uid = params["uid"]
      black_uid = params["black_uid"]

      User.rem_blacklist(uid, black_uid)

      ok(data: %{result: "success"})
    end
  end
end
