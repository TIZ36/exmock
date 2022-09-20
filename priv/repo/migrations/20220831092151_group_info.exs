defmodule Exmock.Repo.Migrations.GroupInfo do
  use Ecto.Migration

  def change do
    create table(:group_info, primary_key: false) do
      add :group_id, :bigint, primary_key: true
      add :group_name, :string
      add :group_avatar, :string
      add :group_type, :integer
      add :group_sub_type, :integer
      add :server_id, :string
      add :manager_list, :blob
      add :at_all_per_day, :integer

      timestamps()
    end
  end
end
