defmodule GroupInfoMapper do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  mapper "query_group_by_id", params: id do
    query =
      from group_info in "group_info",
           where: group_info.id == ^id,
           select: %{
             group_id: group_info.id,
             group_data: group_info.data
           }

    Exmock.Repo.one(query)
  end

  mapper "insert_group_info", params: %GroupInfoPo.GroupInfo{} = input do
    Exmock.Repo.insert(input)
  end
end