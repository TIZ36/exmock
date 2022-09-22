defmodule Exmock.Data.UserGroup do
  @moduledoc """
  user_group 相关的数据查询，内建缓存
  """

  use Nebulex.Caching
  alias Exmock.Data.Schema.UserGroupMapping

  alias Exmock.EtsCache, as: Cache
  alias Exmock.Repo
  import Ecto.Query

  @ttl :timer.hours(1)

  @doc """
  建立user group关系
  """
  @decorate cache_evict(
              cache: Cache,
              key: {UserGroupMappingU, uid}
            )
  def user_join(gid, uid) when is_integer(gid) and is_integer(uid) do
    attrs = %{uid: uid, group_id: gid}

    %UserGroupMapping{}
    |> UserGroupMapping.changeset(attrs)
    |> Repo.insert()
  end

  @decorate cacheable(
              cache: Cache,
              key: {UserGroupMappingU, uid},
              opts: [ttl: @ttl]
            )
  def query_user_groups(uid) when is_integer(uid) do
    query =
      from(ugp in UserGroupMapping,
        where: ugp.uid == ^uid,
        select: ugp.group_id
      )

    Repo.all(query)
  end

  @decorate cacheable(
              cache: Cache,
              key: {UserGroupMappingG, gid},
              opts: [ttl: @ttl]
            )
  def query_group_users(gid) when is_integer(gid) do
    query =
      from(gup in UserGroupMapping,
        where: gup.group_id == ^gid,
        select: gup.uid
      )

    Repo.all(query)
  end

  #  def get_group_users(gid) do
  #    query = from ugm in
  #  end
end
