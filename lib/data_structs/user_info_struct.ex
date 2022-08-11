defmodule UserInfoStruct do
  @derive Jason.Encoder
  defstruct [
    :avatar,
    :kingdom,
    :guild,
    :badge_url,
    :sub_title_list,
    :avatar_frame_url,
    :bubble_configs,
    :vip_level,
    :show_vip,
    :level,
    :game_extra,
    :sex,
    :emblem_urls,
    :create_time,
    :text_color,
    :user_type,
    :user_name,
    :uid
  ]
end