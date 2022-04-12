defmodule Exmock.Repo.Migrations.GroupUserMap do
  use Ecto.Migration

  def change do
    create table(:group_user_map, primary_key: false) do
      add :gid, :bigint, primary_key: true
      add :uid, :bigint, primary_key: true

      timestamps()
    end
  end
end
