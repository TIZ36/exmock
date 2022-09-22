defmodule Exmock.Gen.GroupInfo do

  @moduledoc false
  use Exmock.Const

  def gen_group_info(group_name, group_sub_type \\ 0) do
    %{
      group_id: Exmock.IdUtil.gen_id(),
      group_avatar: Faker.Avatar.image_url(),
      group_name: group_name,
      group_sub_type: group_sub_type,
      group_type: @group_type_group,
      manager_list: "[]",
      server_id: "1",
      at_all_per_day: 10
    }
  end
end
