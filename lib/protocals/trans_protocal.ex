defprotocol DTA.TransProtocol do
  @spec trans(t) :: Any.t()
  def trans(value)
end

defimpl DTA.TransProtocol, for: Exmock.Data.Schema.GroupConfig do
  @dta_group_config [
    group_id: :Integer,
    positions: :Binary
  ]

  def trans(group_config) do
    group_config
    |> Map.take(Keyword.keys(@dta_group_config))
    |> Map.get(:positions, :erlang.term_to_binary([]))
    |> :erlang.binary_to_term()
  end
end

defimpl DTA.TransProtocol, for: Exmock.Data.Schema.UserInfo do
  @dta_user_info [
    uid: :Integer,
    data: :Binary
  ]

  def trans(user_info_schema) do
    user_info_schema
    |> Map.take(Keyword.keys(@dta_user_info))
    |> Map.get(:data, :erlang.term_to_binary(%{}))
    |> :erlang.binary_to_term()
  end
end

defimpl DTA.TransProtocol, for: Exmock.Data.Schema.GroupInfo do
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

  alias Exmock.Core.Util

  def trans(group_info_schema) do
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
          if Util.type_ok?(v, Keyword.get(@dta_group_info, k)) do
            Map.put(acc, k, v)
          else
            acc
          end
      end
    )
  end
end
