defmodule Exmock.Repo.Migrations.BubbleConfig do
  use Ecto.Migration

  def change do
    create table(:bubble_config, primary_key: false) do
      add :left_normal, :json
      add :left_pressed, :json
      add :right_normal, :json
      add :right_pressed, :json
      add :user_info_uid, :integer, primary_key: true

      timestamps()
    end
  end
end
