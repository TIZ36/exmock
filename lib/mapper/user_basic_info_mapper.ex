defmodule UserBasicInfoMapper do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  mapper "query_user", params: uid do
    query =
      from user_basic in UserBasicInfoPo.table(),
           where: user_basic.uid == ^uid,
           select: %{
             uid: user_basic.uid,
             cur_stage: user_basic.cur_stage,
             maincity_level: user_basic.maincity_level
           }


    case Exmock.Repo.one(query) do
      nil ->
        nil
      re ->
        re
    end
  end

  mapper "insert_user_info", params: %UserBasicInfoPo.UserBasicInfo{} = po do
    Exmock.Repo.insert(po)
  end
end