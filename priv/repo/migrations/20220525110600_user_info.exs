defmodule Exmock.Repo.Migrations.UserInfo do
  use Ecto.Migration

  def change do
    create table(:user_info, primary_key: false) do
      add :uid, :integer, primary_key: true
      add :user_name, :string
      add :avatar, :string
      add :badge_url, :string
      add :avatar_frame_url, :string
      add :vip_level, :integer
      add :show_vip, :boolean
      add :level, :integer
      add :game_extra, :string
      add :sex, :integer
      add :emblem_urls, :json
      add :create_time, :integer
      add :text_color, :string
      add :user_type, :integer
      add :kingdom_id, references(:kingdom, column: :kingdom_id, type: :integer)
      add :guild_id, references(:guild, column: :id, type: :integer)

      timestamps()
    end
  end
end
