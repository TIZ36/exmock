defmodule Exmock.Service.IMNotify do
  @moduledoc """
  通知IM，mock服务器产生的关系变化
    1、change_members_v2：群组关系变化
    2、change_relation: 好友关系变更
    3、change_blacklistRelation: 变更黑名单关系
  """

  alias Exmock.Data.User
  alias Exmock.Data.Group

  use Exmock.Constants

  require Logger

  @doc """
  前置条件：
    1、要存在group
    2、用户已经在群组内了


  chang_mem_list:

    [item], item: 每个群组的数据前置自己做好合并
    %{
     leave:  [{group_id, uids}]
     add:    [{group_id, uids}]
     switch: [{from, to, uids}]
    }
  """
  def change_members_v2(ope, %{switch: _switches} = changes) do
    {l, a} =
      Enum.reduce(changes, {%{}, %{}},
        fn {from, to, uids}, {leave_map, add_map} ->
          l =
            case Map.keys(leave_map) |> Enum.member?(from) do
              true ->
                old =  Map.get(leave_map, from)
                new = (old ++ uids) |> Enum.dedup()

                Map.put(leave_map, from, new)
              false ->
                Map.put(leave_map, from, uids)
            end

           a =
             case Map.keys(add_map) |> Enum.member?(to) do
               true ->
                 old =  Map.get(add_map, to)
                 new = (old ++ uids) |> Enum.dedup()

                 Map.put(add_map, to, new)
               false ->
                 Map.put(add_map, to, uids)
             end

           {l, a}
        end)

    leaves =
      Map.get(changes, :leave, %{})
      |> Map.merge(l, fn _k, v1, v2 -> (v1 ++ v2) |> Enum.dedup() end)
    adds =
      Map.get(changes, :add, %{})
      |> Map.merge(a, fn _k, v1, v2 -> (v1 ++ v2) |> Enum.dedup() end)


      change_members_v2(ope, %{leave: leaves, add: adds})
  end
  # only contains leave, add
  def change_members_v2(ope, %{leave: leaves, add: adds} = _change) do
    access_type = Exmock.EnvCfg.get_at!()
    leave_part =
      leaves
      |> Enum.reduce([], fn {group_id, uids} ->
        users = build_user(uids)

        %{group_id: gid, group_name: gname, group_type: gt, group_sub_type: gst} =
          Group.query_group_info_by_gid(group_id) |> DTA.TransProtocol.trans()

        %{
          operator: ope,
          users: users,
          groupId: gid,
          groupType: gt,
          groupName: gname,
          groupSubType: gst,
          changeType: @group_change_type_leave
        }
      end)


      add_part =
        adds
        |> Enum.reduce([], fn {group_id, uids} ->
          users = build_user(uids)
          group_owners = build_group_owners(group_id)
          %{group_name: gname, group_type: gt, group_sub_type: gst} =
            Group.query_group_info_by_gid(group_id) |> DTA.TransProtocol.trans()

          %{
            operator: ope,
            users: users,
            groupId: group_id,
            groupType: gt,
            groupName: gname,
            groupSubType: gst,
            changeType: @group_change_type_add,
            groupOwners: group_owners
          }
        end)


        body = %{accessType: access_type, changeMemList: leave_part ++ add_part}


        re = Exmock.HttpClient.http_post("http://localhost:9141/notification.change_members_v2", body)
        Logger.warn("change_members_v2 returns: #{inspect(re)}")

  end

  def change_relation(uid, target_uids, op, lang \\ "en") do
    at = Exmock.EnvCfg.get_at!()
    body = %{
      accessType: at,
      uid: uid,
      targetUIds: target_uids,
      op: op,
      lang: lang
    }

    re = Exmock.HttpClient.http_post("http://localhost:9141/notification.change_relation", body)
    Logger.warn("change_relation returns: #{inspect(re)}")
  end

  def change_blacklist(uid, blacklist, blacklisted) do
    at = Exmock.EnvCfg.get_at!()
    body = %{
      accessType: at,
      uid: uid,
      blacklist: blacklist,
      blacklisted: blacklisted
    }

    url = "http://localhost:9141/notification.change_blacklistRelation"
    re = Exmock.HttpClient.http_post(url, body)
    Logger.warn("change_blacklistRelation returns: #{inspect(re)}")
  end

  def build_user(uids) do
    Enum.map(uids, fn uid ->
      %{uid: uid, user_name: uname} = User.query_user_info_by_id(uid)

      %{uid: uid, userName: uname}
    end)
  end

  def build_group_owners(group_id) do
    Group.query_group_owners(group_id)
    |> build_user()
  end

end
