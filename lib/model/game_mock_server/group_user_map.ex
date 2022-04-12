defmodule Exmock.Model.GameMockServer.GroupUserMap do
  use Ecto.Schema
  import Ecto.Query, warn: false

  @primary_key false
  schema "group_user_map" do
    field(:uid, :integer, primary_key: true)
    field(:gid, :integer, primary_key: true)

    timestamps()
  end

  def query_group_users(gid) do
    query =
      from users in "group_user_map",
        where: users.gid == ^gid,
        select: users.uid

      Exmock.Repo.all(query)
  end

  def query_user_groups(uid) do
    query =
      from groups in "group_user_map",
        where: groups.uid == ^uid,
        select: groups.gid

      Exmock.Repo.all(query)
  end

  def insert_group_user_map(gid, uid) do
    changeset = %__MODULE__{gid: gid, uid: uid}
    Exmock.Repo.insert(changeset)
  end

  def insert_group_info(%{gid: gid, uid: uid} = _group_user_map) do
    insert_group_user_map(gid, uid)
  end
end
