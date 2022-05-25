defmodule UserInfoBo do
  use Ezx.Orm.Model

  model UserInfo,
        fields: (
          field :uid, :integer, primary_key: true
          field :user_name, :string
          field :avatar, :string
          field :badge_url, :string
          field :avatar_frame_url, :string
          field :vip_level, :integer
          field :show_vip, :boolean
          field :level, :integer
          field :game_extra, :string
          field :sex, :integer
          field :emblem_urls, {:array, :string}
          field :create_time, :integer
          field :text_color, :string
          field :user_type, :integer
          field :kingdom_id, :integer
          field :guild_id, :integer

          has_one :bubble_config, BubbleConfigPo.BubbleConfig, foreign_key: :user_info_uid, references: :uid
          has_one :kingdom, KingdomPo.Kingdom, foreign_key: :kingdom_id, references: :kingdom_id
          has_one :guild, GuildPo.Guild, foreign_key: :id, references: :guild_id
          has_many :subtitle_item, SubTitleItemPo.SubTitleItem, foreign_key: :user_info_uid, references: :uid

          timestamps()
          )
end