defmodule Exmock.Repo.Migrations.UserBlacklist do
  use Ecto.Migration

  def change do
    create table(:user_blacklist, primary_key: false) do
      add :one_uid, :bigint
      add :ano_uid, :bigint
      add :relate_hash, :string
      add :black_state, :integer

      timestamps
    end
  end
end
