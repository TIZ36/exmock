defmodule Exmock.Repo.Migrations.UserBasicInfo do
  use Ecto.Migration

  def change do
    create table(:basic_info, primary_key: false) do
      add :uid, :bigint, primary_key: true
      add :cur_stage, :integer
      add :maincity_level, :integer

      timestamps()
    end
  end
end
