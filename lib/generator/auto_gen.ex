defmodule Exmock.AutoGen do
  @moduledoc """
  自动生成数据
  """

  def gen_user(s, e) do
    ids = :lists.seq(s, e)

    Enum.each(ids, fn id ->
      Exmock.Service.User.post("user.create", %{"uid" => id})
    end)
  end

  def gen_group(s, e) do
    ids = :lists.seq(s, e)

    Enum.each(ids, fn _id ->
      Exmock.Service.Group.post("group.create", %{})
    end)
  end

  defmodule Kingdoms do
    @moduledoc false
    def new(id) do
      Exmock.Default.kingdom(id)
    end
  end

  defmodule Guilds do
    use Exmock.Const
    @moduledoc false
    def create_group(group_name, group_sub_type) do
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
    def new() do
      guild_id = Exmock.IdUtil.gen_id()
      name = Faker.Team.name()
      avatar_url = "http://imimg.lilithcdn.com/personal/race/koon.png"
      abbr_name = String.slice(name, 0, 3)

      %Guild{id: guild_id, name: name, avatar_url: avatar_url, abbr_name: abbr_name}
    end
  end

  defmodule SubtitleLists do
    @moduledoc false
    def new() do
      [%Subtitle{}]
    end
  end

  defmodule BubbleConfigs do
    @moduledoc false
    def new() do
      %{
        left_normal: %BubbleConfig{},
        left_pressed: %BubbleConfig{},
        right_normal: %BubbleConfig{},
        right_pressed: %BubbleConfig{}
      }
    end
  end

  defmodule UserInfo do
    @moduledoc false
    def new() do
      user_info_data = %{uid: uid} = Exmock.AutoGen.UserInfoStructs.new()

      %{
        uid: uid,
        data:
          user_info_data
          |> :erlang.term_to_binary()
      }
    end

    def new(id) do
      user_info_data = %{uid: uid} = Exmock.AutoGen.UserInfoStructs.new(id)

      %{
        uid: uid,
        data:
          user_info_data
          |> :erlang.term_to_binary()
      }
    end
  end

  defmodule UserInfoStructs do
    @moduledoc false
    def new() do
      uid = Exmock.IdUtil.gen_id()

      %UserInfoStruct{
        uid: uid,
        avatar: Faker.Avatar.image_url(),
        kingdom: Exmock.AutoGen.Kingdoms.new(uid),
        guild: Exmock.AutoGen.Guilds.new(),
        badge_url: "",
        sub_title_list: Exmock.AutoGen.SubtitleLists.new(),
        avatar_frame_url: "",
        bubble_configs: Exmock.AutoGen.BubbleConfigs.new(),
        vip_level: 0,
        show_vip: false,
        level: 10,
        game_extra: "{}",
        sex: 0,
        emblem_urls: [],
        create_time: Exmock.TimeUtil.now_sec(),
        text_color: "#000000",
        user_type: 0,
        user_name: Faker.Person.name()
      }
    end

    def new(id) do
      %UserInfoStruct{
        uid: id,
        avatar: Faker.Avatar.image_url(),
        kingdom: Exmock.AutoGen.Kingdoms.new(id),
        guild: Exmock.AutoGen.Guilds.new(),
        badge_url: "",
        sub_title_list: Exmock.AutoGen.SubtitleLists.new(),
        avatar_frame_url: "",
        bubble_configs: Exmock.AutoGen.BubbleConfigs.new(),
        vip_level: 0,
        show_vip: false,
        level: 10,
        game_extra: "{}",
        sex: 0,
        emblem_urls: [],
        create_time: Exmock.TimeUtil.now_sec(),
        text_color: "#000000",
        user_type: 0,
        user_name: Faker.Person.name()
      }
    end
  end
end
