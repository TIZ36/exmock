defmodule Exmock.Service.User do
  use Exmock.Common.ErrorCode

  def handle("basicInfo" = _api, %{uid: uid} = _params) do
    case UserInfoMapper.query_user(uid) do
      nil ->
        fail(@ecode_not_found)
      re ->
        ok(data: re)
    end
  end
end