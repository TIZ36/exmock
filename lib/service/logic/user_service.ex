defmodule Exmock.Service.User do
  @moduledoc """
  用户相关业务
  """

  # exmock std resp
  use Exmock.Resp

  # exmock service decorator
  use ServiceParamsDecorator

  require Logger

  # alias of Data-Control Layer
  alias Exmock.Data.User
  alias Exmock.Data.Group
  alias Exmock.Data.UserGroup

  # alias of Data-Schema Layer
  alias Exmock.Data.Schema.GroupInfo

  @doc """
  GET apis, user相关的api获取
  """
  def get(_api, _params)

  # 获取 user.basicinfo
  @decorate trans(params, [{"uid", :Integer}])
  def get("user.basicinfo", params) do
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

  #获取user.info
  @decorate trans(params, [{"uid", :Integer}, {"language", :String}])
  def get("user.info", params) do
    case User.query_user_info_by_id(params["uid"]) do
      nil ->
        fail(@ecode_not_found)

      {:fail, _reason} ->
        fail(@ecode_db_error)

      %Exmock.Data.Schema.UserInfo{} = user_info_schema ->
        re = DataType.TransProtocol.trans_out(user_info_schema)
        ok(data: re)
    end
  end

  def get("user.batchInfo", %{"users" => users_url_encoded} = _params) do
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

  # 获取群组
  @decorate trans(params, [{"uid", :Integer}, {"language", :String}])
  def get("user.groups", params) do
    no_panic "user.groups", fallback: fail(@ecode_service_reject), use_throw: true do
      re = UserGroup.query_user_groups(params["uid"])

      # 所有人都在global room 和 alliance 里面
      re = re ++ [1, 2]
      group_info_list =
        Enum.reduce(re, [], fn gid, acc ->
          case Group.query_group_info_by_gid(gid) do
            %GroupInfo{} = group_info_struct ->
              [group_info_struct |> DataType.TransProtocol.trans_out() | acc]

            _ ->
              throw(fail(@ecode_not_found))
          end
        end)

      ok(data: group_info_list)
    end
  end

#  def get("config.infoUI", _params) do
#  end

  # def get("presence", %{"uids" => uids} = params) do
  # end

  # 获取好友
  @decorate trans(params, [{"uid", :Integer}, {"language", :String}])
  def get("user.friends", params) do
    no_panic "user.friends", fallback: fail(@ecode_service_reject) do
      re =
        User.query_user_friends(params["uid"])
        |> Enum.reduce([], fn uid, acc ->
          case User.query_user_info_by_id(uid) do
            %Exmock.Data.Schema.UserInfo{} = user_info_schema ->
              %{avatar: avatar, uid: uid, user_name: user_name} =
                DataType.TransProtocol.trans_out(user_info_schema)

              [%{id: uid, avatar: avatar, name: user_name} | acc]

            _ ->
              Logger.warn("uid #{uid} cannot find in userinfo")
              acc
          end
        end)

      ok(data: re)
    end
  end

  # 获取黑名单数据
  @decorate trans(params, [{"uid", :Integer}])
  def get("user.blacklist", params) do
    no_panic "blacklist", fallback: ok(data: []) do
      uid = params["uid"]
      blacklist = User.get_blacklist(uid)
      blackedlist = User.get_blacked_list(uid)

      ok(data: %{blacklist: blacklist, blacklisted: blackedlist})
    end
  end

  # 好友相关
  #获取好友请求
  @decorate trans(params, [{"uid", :Integer}])
  def get("user.friend_reqs", params) do
    no_panic "friend_reqs", fallback: fail(@unknown_err) do
      uid = params["uid"]
      requests = Exmock.Service.Friend.get_friend_reqs(uid)
      ok(data: requests)
    end
  end

  ### post ###
  @decorate trans(params, [{"uid", :Integer}])
  def post("user.create", params) do
    no_panic "user.create", fallback: fail(@ecode_service_reject) do
      input_uid = Map.get(params, "uid", nil)

      user_info =
        if input_uid do
          Exmock.AutoGen.UserInfo.new(input_uid)
        else
          Exmock.AutoGen.UserInfo.new()
        end

      attrs = user_info |> Map.take([:uid, :data])

      IO.inspect(attrs)
      case User.create_user(attrs) do
        {:fail, reason} ->
          Logger.error("user.create fail, reason: #{inspect(reason)}")
          fail(@ecode_db_error)

        {:ok,
          %Exmock.Data.Schema.UserInfo{
            data: data_bin,
            uid: uid
          }
        } ->
          User.create_user_basicinfo(%{uid: uid, cur_stage: 1, maincity_level: rem(uid, 100)})
          ok(data: %{info: :erlang.binary_to_term(data_bin),basicinfo: %{uid: uid, cur_stage: 1, maincity_level: rem(uid, 100)}})

        _ ->
          fail(@unknown_err)
      end
    end
  end

  #
  # 添加好友，user.add_friend
  #  uid, fid
  #  -> redis_contains?
  #  -> is_friend?
  #  -> Exmock.RedisCache
  #
  @decorate trans(params, [{"from_uid", :Integer}, {"to_uid", :Integer}, {"msg", :String}])
  def post("user.add_friend", params) do
    no_panic "add_friend", fallback: fail(@ecode_service_reject) do
      from_uid = params["from_uid"]
      to_uid = params["to_uid"]
      msg = params["msg"]

      User.query_user_info_by_id(to_uid)
      User.query_user_info_by_id(from_uid)

      case Exmock.Service.Friend.add_friend_req(to_uid, from_uid, msg) do
      {:ok, _request_id} ->
          ok(data: %{})

        _ ->
          fail(@ecode_dup_req)
      end
    end
  end

  @doc """
  接受好友
  """
  @decorate trans(params, [{"uid", :Integer}, {"request_id", :String}])
  def post("user.accept_friend", params) do
    no_panic "accept_friend", fallback: fail(@unknown_err) do
      uid = params["uid"]
      request_id = params["request_id"]

      case Exmock.Service.Friend.accept_friend_req(uid, request_id) do
        {:ok, target_id} ->
          notify_im_change_relation(uid, [target_id], @op_be_friend)
          ok(data: %{})

        {:fail, reason} ->
          Logger.error("#{inspect(reason)}")
          fail(@ecode_service_reject)
      end
    end
  end

  # 删除好友，user.del_friend
  @decorate trans(params, [{"uid", :Integer}, {"fid", :Integer}])
  def post("user.del_friend", params) do
    no_panic "user.del_friend", fallback: fail(@ecode_service_reject) do
      uid = params["uid"]
      ano_uid = params["fid"]

      case User.del_friend(%{one_uid: uid, ano_uid: ano_uid}) do
        {:ok, _} ->
          notify_im_change_relation(uid, [ano_uid], @op_rm_friend)
          ok(data: %{})

        _ ->
          throw(fail(@ecode_db_error))
      end
    end
  end

  # 添加黑名单
  @decorate trans(params, [{"uid", :Integer}, {"black_uid", :Integer}])
  def post("user.add_blacklist", params) do
    no_panic "user.add_blacklist", fallback: fail(@ecode_service_reject) do
      uid = params["uid"]
      black_uid = params["black_uid"]

      User.add_blacklist(uid, black_uid)
      notify_im_change_blacklist(uid)

      ok(data: %{})
    end
  end

  # 删除黑名单
  @decorate trans(params, [{"uid", :Integer}, {"black_uid", :Integer}])
  def post("user.del_blacklist", params) do
    no_panic "user.del_blacklist", fallback: fail(@unknown_err) do
      uid = params["uid"]
      black_uid = params["black_uid"]

      User.rem_blacklist(uid, black_uid)

      notify_im_change_blacklist(uid)

      ok(data: %{})
    end
  end

  def notify_im_change_relation(uid, target_uids, ope) do
    Exmock.Service.IMNotify.change_relation(uid, target_uids, ope)
  end
  def notify_im_change_blacklist(uid) do
    blacklist = User.get_blacklist(uid)
    blackedlist = User.get_blacked_list(uid)

    Exmock.Service.IMNotify.change_blacklist(uid, blacklist, blackedlist)
  end
end
