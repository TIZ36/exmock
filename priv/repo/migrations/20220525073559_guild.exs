defmodule Exmock.Repo.Migrations.Guild do
  use Ecto.Migration

  def change do
    create table(:guild, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string
      add :avatar_url, :string
      add :abbr_name, :string

      timestamps()
    end
  end
end
