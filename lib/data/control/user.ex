defmodule Exmock.Data.User do
  @moduledoc """
  user相关的数据查询，内建缓存
  """

  use Nebulex.Caching
  use Exmock.Const
  use Bitwise

  alias Exmock.Data.Schema.UserBasicInfo
  alias Exmock.Data.Schema.UserInfo
  alias Exmock.Data.Schema.UserFriend
  alias Exmock.Data.Schema.UserBlacklist

  alias Exmock.EtsCache, as: Cache
  alias Exmock.Repo
  import Ecto.Query

  require Logger

  @ttl :timer.hours(1)

  # ====== table: basic_info, schema: Exmock.Data.Schema.UserBasicInfo  ======#
  @decorate cache_put(
              cache: Cache,
              key: {UserBasicInfo, attrs.uid}
            )
  def create_user_basicinfo(attrs) do
    %UserBasicInfo{}
    |> UserBasicInfo.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  查找user basic info， with cache
  """
  @decorate cacheable(
              cache: Cache,
              key: {UserBasicInfo, uid},
              opts: [
                ttl: @ttl
              ]
            )
  def query_user_basicinfo_by_id(uid) do
    Repo.get!(UserBasicInfo, uid)
  end

  @decorate cache_put(
              cache: Cache,
              key: {UserBasicInfo, attrs.uid}
            )
  def update_user_basicinfo_by_uid(%{uid: id} = attrs) do
    user_basic_info = query_user_basicinfo_by_id(id)

    user_basic_info
    |> UserBasicInfo.update_changeset(attrs)
    |> Repo.update!()
  end

  # ====== table: user_info, schema: Exmock.Data.Schema.UserInfo ======#
  def create_user(%{uid: _uid, data: _data} = attrs) do
    %UserInfo{}
    |> UserInfo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  查找 user info, with cache
  """
  @decorate cacheable(
              cache: Cache,
              key: {UserInfo, uid},
              opts: [
                ttl: @ttl
              ]
            )
  def query_user_info_by_id(uid) do
    Repo.get!(UserInfo, uid)
  end

  @doc """
  获取多人
  """
  def batch_query_user_info_by_ids(uids) do
    query =
      from(
        u in UserInfo,
        where: u.uid in ^uids,
        select: u.data
      )

    Repo.all(query)
    |> Enum.map(fn data_bin -> :erlang.binary_to_term(data_bin) end)
  end

  # ====== table: user_friend, schema: Exmock.Data.Schema.UserFriend ======#
  @doc """
  成为好友
  """
  @decorate cache_evict(
              cache: Cache,
              keys: [{UserFriend, attr.one_uid}, {UserFriend, attr.ano_uid}]
            )
  def been_friend(%{one_uid: _one_uid, ano_uid: _ano_uid} = attr) do
    %UserFriend{}
    |> UserFriend.changeset(attr)
    |> Repo.insert!()
  end

  @doc """
  查询好友
  """
  @decorate cacheable(
              cache: Cache,
              key: {UserFriend, uid},
              opts: [
                ttl: @ttl
              ]
            )
  def query_user_friends(uid) do
    query =
      from(
        uf in UserFriend,
        where: uf.one_uid == ^uid or uf.ano_uid == ^uid,
        select: uf
      )

    v =
      query
      |> Repo.all()

    Logger.info("#{inspect(v)}")

    v
    |> Enum.map(
         fn
           %_{one_uid: ^uid, ano_uid: fid} ->
             fid

           %_{one_uid: fid, ano_uid: ^uid} ->
             fid
         end
       )
  end

  @doc """
  删除好友，TODO: 后面改为伪删除
  """
  @decorate cache_evict(
              cache: Cache,
              keys: [{UserFriend, uid}, {UserFriend, ano_uid}]
            )
  def del_friend(%{one_uid: uid, ano_uid: ano_uid}) do
    rh = UserFriend.relate_hash(uid, ano_uid)
    uf = Repo.get!(UserFriend, rh)

    Repo.delete(uf)
  end

  # ---- user.blacklist ----#
  @decorate cache_evict(
              cache: Cache,
              keys: [{UserBlacklist, uid}, {UserBlackedlist, blacked_uid}]
            )
  def add_blacklist(uid, blacked_uid) do
    query =
      from(
        ubl in UserBlacklist,
        where: ubl.one_uid == ^uid and ubl.ano_uid == ^blacked_uid,
        select: ubl
      )

    case Repo.one(query) do
      nil ->
        # 这里不检查用户存在
        attrs = %{one_uid: uid, ano_uid: blacked_uid, black_state: @blacked}

        %UserBlacklist{}
        |> UserBlacklist.changeset(attrs)
        |> Repo.insert()

      %_{black_state: bs} = user_blacklist_record ->
        attrs = %{black_state: bs ||| @blacked}

        user_blacklist_record
        |> UserBlacklist.update_changeset(attrs)
        |> Repo.update()
    end
  end

  @decorate cache_evict(
              cache: Cache,
              keys: [{UserBlacklist, uid}, {UserBlackedlist, blacked_uid}]
            )
  def rem_blacklist(uid, blacked_uid) do
    query =
      from(
        ubl in UserBlacklist,
        where:
          ubl.one_uid == ^uid and ubl.ano_uid == ^blacked_uid and ubl.black_state == @blacked,
        select: ubl
      )

    case Repo.one(query) do
      nil ->
        {:ok, "no change"}

      %_{black_state: bs} = user_blacklist_record ->
        attrs = %{black_state: bs &&& @no_blacked}

        user_blacklist_record
        |> UserBlacklist.update_changeset(attrs)
        |> Repo.update()
    end
  end

  @decorate cacheable(
              cache: Cache,
              key: {UserBlacklist, uid},
              opts: [
                ttl: @ttl
              ]
            )
  def get_blacklist(uid) do
    query =
      from(
        ubl in UserBlacklist,
        where: ubl.one_uid == ^uid and ubl.black_state == @blacked,
        select: ubl.ano_uid
      )

    query
    |> Repo.all()
  end

  @decorate cacheable(
              cache: Cache,
              key: {UserBlackedlist, uid},
              opt: [
                ttl: @ttl
              ]
            )
  def get_blacked_list(uid) do
    query =
      from(
        ubl in UserBlacklist,
        where: ubl.ano_uid == ^uid and ubl.black_state == @blacked,
        select: ubl.one_uid
      )

    query
    |> Repo.all()
  end
end
