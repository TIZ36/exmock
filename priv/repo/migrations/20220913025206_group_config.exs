defmodule Exmock.Repo.Migrations.GroupConfig do
  use Ecto.Migration

  def change do
    create table(:group_config, primary_key: false) do
      add :group_id, :bigint, primary_key: true
      add :positions, :blob

      timestamps
    end
  end
end
