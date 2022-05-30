defmodule Exmock.Service.Group do
  @moduledoc """
  本模块用于 group 【游戏群组】的相关业务
  """

  use Ezx.Service


  use Exmock.Common.ErrorCode

  service "group.create", %GroupPo.Group{
            group_id: gid,
            group_name: g_name,
            group_avatar: group_avatar,
            group_type: group_type,
            group_sub_type: group_sub_type
          } = bo do
    case GroupMapper.create_group(bo) do
      {:ok, _re} ->
        ok(
          data: %{
            group_id: gid,
            group_name: g_name,
            group_avatar: group_avatar,
            group_type: group_type,
            group_sub_type: group_sub_type
          }
        )
      _ ->
        fail(@ecode_db_error)
    end
  end

  service "group.add_mem", %{} = _params do

  end

  service "group.remove_mem", %{} = _params do
    1
  end

  def toBo(
        %{
          group_name: g_name,
          group_avatar: group_avatar,
          group_type: group_type
        } = dto,
        service: "create"
      ) do
    {:ok, gid} = Snowflake.next_id()
    group_sub_type = Map.get(dto, :group_sub_type, 0)
    %GroupPo.Group{
      group_id: gid,
      group_name: g_name,
      group_avatar: group_avatar,
      group_type: group_type,
      group_sub_type: group_sub_type
    }
  end
end