defmodule Exmock.Service.User do
  use ErrorCode

  def handle("basicInfo" = _api, %{uid: uid} = _params) do
    case UserInfoMapper.query_user(uid) do
      a ->
       3
      nil ->
        @ecode_not_found
      re ->
        re

    end
  end
end