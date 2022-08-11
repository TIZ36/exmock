defmodule AutoGen do
  @moduledoc """
  自动生成数据
  """

  defmodule Kingdoms do
    def new(id) do
      Exmock.Defaults.kingdom(id)
    end
  end

  defmodule Guilds do
    def new() do
      guild_id = Exmock.IdUtil.gen_id()
      name = Faker.Team.name()
      avatar_url = "http://imimg.lilithcdn.com/personal/race/koon.png"
      abbr_name = String.slice(name, 0, 3)

      %Guild{id: guild_id, name: name, avatar_url: avatar_url, abbr_name: abbr_name}
    end
  end

  defmodule SubtitleLists do
    def new() do
      [%Subtitle{}]
    end
  end

  defmodule BubbleConfigs do
    def new() do
      %{
        left_normal: %BubbleConfig{},
        left_pressed: %BubbleConfig{},
        right_normal: %BubbleConfig{},
        right_pressed: %BubbleConfig{},
      }
    end
  end

  defmodule UserInfo do
    def new() do
      user_info_data = %{uid: uid} = AutoGen.UserInfoStructs.new()
      %User.UserInfo{
        uid: uid,
        data: user_info_data
              |> :erlang.term_to_binary()
      }
    end
  end

  defmodule UserInfoStructs do
    def new() do
      uid = Exmock.IdUtil.gen_id()
      %UserInfoStruct{
        uid: uid,
        avatar: Faker.Avatar.image_url(),
        kingdom: AutoGen.Kingdoms.new(uid),
        guild: AutoGen.Guilds.new(),
        badge_url: "",
        sub_title_list: AutoGen.SubtitleLists.new(),
        avatar_frame_url: "",
        bubble_configs: AutoGen.BubbleConfigs.new(),
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