defimpl DataType.TransProtocol, for: Exmock.Data.Schema.GroupConfig do
  @dta_group_config [
    group_id: :Integer,
    positions: :Binary
  ]

  def trans_out(group_config) do
    group_config
    |> Map.take(Keyword.keys(@dta_group_config))
    |> Map.get(:positions, :erlang.term_to_binary([]))
    |> :erlang.binary_to_term()
  end

  def trans_in(v) do
    v
  end
end

defimpl DataType.TransProtocol, for: Exmock.Data.Schema.UserBasicInfo do
  @user_basicinfo_fields_declare [
    cur_stage: :Integer,
    maincity_level: :Integer,
    uid: :Integer
  ]

  def trans_out(user_basicinfo) do
    user_basicinfo
    |> Map.take(Keyword.keys(@user_basicinfo_fields_declare))
  end

  def trans_in(v) do
    v
  end
end

defimpl DataType.TransProtocol, for: Exmock.Data.Schema.UserInfo do
  @dta_user_info [
    uid: :Integer,
    data: :Binary
  ]

  def trans_out(user_info_schema) do
    user_info_schema
    |> Map.take(Keyword.keys(@dta_user_info))
    |> Map.get(:data, :erlang.term_to_binary(%{}))
    |> :erlang.binary_to_term()
  end

  def trans_in(v) do
    v
  end
end


defimpl DataType.TransProtocol, for: Exmock.Data.Schema.GroupInfo do
  @dta_group_info [
    group_id: :Integer,
    group_name: :BitString,
    group_avatar: :BitString,
    group_type: :Integer,
    group_sub_type: :Integer,
    server_id: :BitString,
    # may require trans
    manager_list: :List,
    # may require trans, default 10
    at_all_per_day: :Integer
  ]

  alias Exmock.NPR

  def trans_out(group_info_schema) do
    group_info_schema
    |> Map.take(Keyword.keys(@dta_group_info))
    |> Enum.reduce(
         %{},
         fn
           {:at_all_per_day, nil}, acc ->
             Map.put(acc, :at_all_per_day, 10)

           {:manager_list, v}, acc ->
             Map.put(acc, :manager_list, Jason.decode!(v))

           {k, v}, acc ->
             if NPR.type_ok?(v, Keyword.get(@dta_group_info, k)) do
               Map.put(acc, k, v)
             else
               acc
             end
         end
       )
  end

  def trans_in(v) do
    v
  end
end