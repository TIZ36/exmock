defmodule Exmock.Repo.Migrations.SubtitleItem do
  use Ecto.Migration

  def change do
    create table(:subtitle_item, primary_key: false) do
      add :key, :string
      add :content, :string
      add :bg_url, :string
      add :user_info_uid, :integer, primary_key: true

      timestamps()
    end
  end
end
