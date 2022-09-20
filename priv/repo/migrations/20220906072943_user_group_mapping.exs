defmodule Exmock.Repo.Migrations.UserGroupMapping do
  use Ecto.Migration

  def change do
    create table(:user_group_mapping, primary_key: false) do
      add :uid, :bigint, primary_key: true
      add :group_id, :bigint, primary_key: true

      timestamps
    end

    # composite primary key
    create unique_index(:user_group_mapping, [:uid, :group_id])
  end
end
