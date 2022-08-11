defmodule UserBasicInfoRepo do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  def query_user_basicinfo_by_id(uid) do
    query =
      from user_basic in User.BasicInfo.table(),
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

  def insert_user_basicinfo(%User.BasicInfo{} = user_basic_info) do
    Exmock.Repo.insert(user_basic_info)
  end
end