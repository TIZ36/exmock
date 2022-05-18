defmodule UserInfoMapper do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  mapper "query_user", params: uid do
    query =
      from user in UserInfoPo.table(),
           where: user.id == ^uid,
           select: %{
             id: user.id,
             data: user.data
           }

    case Exmock.Repo.one(query) do
      %{data: bin} = re_map when is_binary(bin) ->
        :erlang.binary_to_term(bin)
      _ ->
        nil
    end
  end

  mapper "insert_user_info", params: %UserInfoPo.UserInfo{} = po do
    Exmock.Repo.insert(po)
  end
end