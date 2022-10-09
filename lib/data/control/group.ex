defmodule Exmock.Data.Group do
  @moduledoc """
  group 相关的数据查询，内建缓存
  """

  use Nebulex.Caching

  alias Exmock.Data.Schema.GroupInfo
  alias Exmock.Data.Schema.GroupConfig
  alias Exmock.Data.Schema.GroupOwner

  alias Exmock.EtsCache, as: Cache
  alias Exmock.Repo
  import Ecto.Query

  @ttl :timer.hours(1)

  def query_all_groups(page, page_size) do
    query =
      from group in GroupInfo,
        limit: ^page_size,
        offset: ^page


    Repo.all(query)
  end

  # 34340617639161856, 34431119105454080
  @decorate cacheable(cache: Cache, key: {GroupInfo, group_id}, opts: [ttl: @ttl])
  def query_group_info_by_gid(group_id) when is_integer(group_id) do
    Repo.get!(GroupInfo, group_id)
  end

  @decorate cache_evict(cache: Cache, key: {GroupInfo, attrs.group_id}, opts: [ttl: @ttl])
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

  def query_group_owners(group_id) do
    case Repo.get(GroupOwner, group_id) do
      %_{group_owners: gos} ->
        :erlang.binary_to_term(gos)
      _ ->
        [0]
    end
  end

  def add_group_owners(group_id, uid) do
    case Repo.get(GroupOwner, group_id) do
      nil ->
        %GroupOwner{}
        |> GroupOwner.changeset(%{group_owners: :erlang.term_to_binary([uid]), group_id: group_id})
        |> Repo.insert()

      %_{group_owners: owners_bin} = group_own ->
        old_owners = owners_bin |> :erlang.binary_to_term()
        new_owners = [uid | old_owners] |> Enum.dedup() |> :erlang.term_to_binary()

        group_own
        |> GroupOwner.update_changeset(%{group_owners: new_owners})
        |> Repo.update()
    end
  end
end
