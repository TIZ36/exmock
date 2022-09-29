defmodule Exmock.Service.Friend do
  @moduledoc """
  处理好友逻辑
  """

  # redis pool
  alias Exmock.RedisCache

  # repos
  alias Exmock.Data.User

  # useful macro
  import Exmock.NPR

  require Logger

  use GenServer

  @friend_req_ttl 7 * 86_400

  def init(_args) do
    {:ok, %{}}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc """
  添加好友请求
  """
  def add_friend_req(uid, from_uid, msg \\ "") do
    case produce_friend_req(uid, from_uid, msg) do
      {:ok, _request_id} =re ->
        re

      {:fail, _reason} = re ->
        re
    end
  end

  @doc """
  拒绝好友请求
  """
  def reject_friend_req(uid, request_id) do
    consume_friend_req(uid, request_id)
    {:ok, "success"}
  end

  @doc """
  获取好友请求列表
  """
  def get_friend_reqs(uid) do
    hash_table_key = friend_request_key(uid)

    req_keys = RedisCache.command!(["HKEYS", hash_table_key])
    case req_keys do
      [] ->
        req_keys
      _ ->
        RedisCache.command!(["HMGET", hash_table_key, req_keys])
        |> Enum.map(&(Jason.decode!(&1)))
        |> Enum.filter(
              fn %{"timestamp" => ts, "ttl" => ttl} ->
                Exmock.TimeUtil.now_sec() - ts < ttl
              end)
        |> Enum.map(&(&1 |> Map.take(["from_uid", "request_id", "request_msg"])))
    end

  end

  @doc """
  获取好友列表
  """
  def get_friend_lists(uid) do
    User.query_user_friends(uid)
  end

  @doc """
  解除好友关系
  """
  def del_friend(uid, fid) do
    User.del_friend(%{uid: uid, fid: fid})
  end

  @doc """
  接受好友请求
  """
  def accept_friend_req(uid, request_id) do
    no_panic "accept_friend_req", fallback: :fail do
      GenServer.call(__MODULE__, {:accept_friend_req, uid, request_id})
    end
  end

  @doc """
  接受好友后成为好友
    1、消费redis里面的请求
    2、数据库保存
  """
  def handle_call({:accept_friend_req, uid, request_id}, _from, state) do
    # 消费好友请求，就算过期的也消费掉
    case consume_friend_req(uid, request_id) do
      {:ok, [request_body_bin, 1]} ->
        %{timestamp: ts, ttl: ttl, from_uid: fid, to_uid: uid} = Jason.decode!(request_body_bin, keys: :atoms)

        if Exmock.TimeUtil.now_sec() - ts <= ttl do
          User.been_friend(%{one_uid: uid, ano_uid: fid})
          {:reply, {:ok, fid}, state}
        else
          {:reply, {:fail, "request expired"}, state}
        end

      _ ->
        {:reply, {:fail, "no such request_id"}, state}
    end
  end

  @doc """
  往redis添加好友请求
  """
  def produce_friend_req(uid, from_uid, msg \\ "") do
    friend_request_cache_key = friend_request_key(uid)
    request_id = request_id(uid, from_uid)

    request_content =
      Jason.encode!(%Exmock.Struct.FriendReq{
        from_uid: from_uid,
        to_uid: uid,
        request_msg: msg,
        request_id: request_id,
        ttl: @friend_req_ttl,
        timestamp: Exmock.TimeUtil.now_sec()
      })

    case RedisCache.command!(
      uid,
      ["HSETNX", friend_request_cache_key, request_id, request_content]
    ) do
      1 ->
        {:ok, request_id}
      _ ->
        {:fail, "already friend"}
    end
  end

  def contains_friend_request?(uid, request_id) do
    friend_request_cache_key = friend_request_key(uid)

    RedisCache.command!(
      uid,
      [
        ["HEXISTS", friend_request_cache_key, request_id]
      ]
    ) == 1
  end

  @doc """
  从redis里面消费好友请求
  """
  def consume_friend_req(uid, request_id) do
    friend_request_cache_key = friend_request_key(uid)

    re = RedisCache.pipeline(uid, [
      ["HGET", friend_request_cache_key, request_id],
      ["HDEL", friend_request_cache_key, request_id]
    ])

    Logger.warn("#{inspect(re)}")
    re

  end

  @doc """
  好友请求id的redis key
  """
  def friend_request_key(uid) do
    "fri_req_id_#{uid}"
  end

  def request_id(uid, fid) do
    seed = "#{uid}-#{fid}"
    :crypto.hash(:md5, seed) |> Base.encode16()
  end
end
