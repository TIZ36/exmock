defmodule Exmock.Service.User do
  use Exmock.Common.ErrorCode
  use Ezx.Service

  @doc """
  ref to https://lilithgames.feishu.cn/wiki/wikcn4N21LbFGIV2lBmFAZ4W4gb#JcWEbg
  Return:
    %{
      "cur_stage" : integer(),
      "maincity_level" : integer()
    }
  """
  service "basicInfo", %{uid: uid} = params do
    case UserBasicInfoMapper.query_user(uid) do
      nil ->
        fail(@ecode_not_found)
      re ->
        ok(data: re)
    end
  end
end
