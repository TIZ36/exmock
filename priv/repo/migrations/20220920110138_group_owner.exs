defmodule Exmock.Repo.Migrations.GroupOwner do
  use Ecto.Migration

  def change do
    create table(:group_owner, primary_key: false) do
      add :group_id, :bigint, primary_key: true
      add :group_owners, :blob

      timestamps
    end
  end
end
