defmodule UserInfoRepo do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  def query_user_info_by_id(uid) do
    query =
      from user_info in User.UserInfo.table(),
           where: user_info.uid == ^uid,
           select: %{
             uid: user_info.uid,
             data: user_info.data,
           }

    case Exmock.Repo.one(query) do
      nil ->
        nil
      %{uid: uid, data: user_info_bin} ->
        :erlang.binary_to_term(user_info_bin)
    end
  end

  def batch_query_user_info_by_ids(uids) do
    query =
      from user_info in User.UserInfo.table(),
           where: user_info.uid in ^uids,
           select: %{
             uid: user_info.uid,
             data: user_info.data
           }

    case Exmock.Repo.all(query) do
      nil ->
        nil
      re ->
        # 查询结果中不会存在未找到的uid，这个需要im自己处理
        # 返回：[%UserInfoStruct{}...]
        Enum.map(re, fn %{uid: uid, data: data} -> :erlang.binary_to_term(data)  end)
    end
  end

  def insert_user_info(%User.UserInfo{} = user_info) do
    Exmock.Repo.insert(user_info)
  end
end