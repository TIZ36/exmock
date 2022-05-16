defmodule UserGroupMapMapper do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  mapper "query_group_users", params: gid do
    query =
      from users in UserGroupMapPo.table(),
           where: users.gid == ^gid,
           select: users.uid

    Exmock.Repo.all(query)
  end

  mapper "query_user_groups", params: uid do
    query =
      from groups in UserGroupMapPo.table(),
           where: groups.uid == ^uid,
           select: groups.gid

    Exmock.Repo.all(query)
  end

  mapper "insert_group_user_map", params: %UserGroupMapPo.UserGroupMap{} = ugm do
    Exmock.Repo.insert(ugm)
  end
end