defmodule Exmock.Repo.Migrations.Group do
  use Ecto.Migration

  def change do
    create table("group", primary_key: false) do
      add :group_id, :bigint, primary_key: true
      add :group_name, :string
      add :group_avatar, :string
      add :group_type, :integer
      add :group_sub_type, :integer

      timestamps()
    end
  end
end
