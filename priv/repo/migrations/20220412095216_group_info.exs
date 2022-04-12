defmodule Exmock.Repo.Migrations.GroupInfo do
  use Ecto.Migration

  def change do
    create table(:group_info, primary_key: false) do
      add :id, :bigint, primary_key: true
      add :data, :blob

      timestamps()
    end
  end
end
