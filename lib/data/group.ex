defmodule Exmock.Data.Group do
  @moduledoc """
  group 相关的数据查询，内建缓存
  """

  use Nebulex.Caching

  alias Exmock.Data.Schema.GroupInfo
  alias Exmock.Data.Schema.GroupConfig

  alias Exmock.EtsCache, as: Cache
  alias Exmock.Repo

  @ttl :timer.hours(1)

  # 34340617639161856, 34431119105454080
  @decorate cacheable(cache: Cache, key: {GroupInfo, group_id}, opts: [ttl: @ttl])
  def query_group_info_by_gid(group_id) when is_integer(group_id) do
    Repo.get!(GroupInfo, group_id)
  end

  @decorate cacheable(cache: Cache, key: {GroupInfo, attrs.group_id}, opts: [ttl: @ttl])
  def update_group_info(%{group_id: gid} = attrs) do
    old_group_info = query_group_info_by_gid(gid)

    old_group_info
    |> GroupInfo.update_changeset(attrs)
    |> Repo.update!()
  end

  def create_new_group_info(attrs) do
    %GroupInfo{}
    |> GroupInfo.changeset(attrs)
    |> Repo.insert()
  end

  ##- group_config -##
  @doc """
  群组的头衔挂饰配置  [{position1}, {position2}...]
  """
  @decorate cacheable(cache: Cache, key: {GroupConfig, group_id}, opts: [ttl: @ttl])
  def query_group_config(group_id) do
    Repo.get(GroupConfig, group_id)
    |> Kernel.||([])
  end

  @decorate cacheable(cache: Cache, key: {GroupOwners, group_id}, opts: [ttl: @ttl])
  def query_group_owners(group_id) do
    Repo.get(GroupOwner, group_id)
    |> Map.take([:group_owners])
    |> :erlang.binary_to_term()
  end
end
