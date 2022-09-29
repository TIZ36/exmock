defmodule Exmock.Repo.Migrations.UserFriend do
  use Ecto.Migration

  def change do
    create table(:user_friend, primary_key: false) do
      add :one_uid, :bigint
      add :ano_uid, :bigint
      add :relate_hash, :string

      timestamps
    end
  end
end
