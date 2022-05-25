defmodule Exmock.Repo.Migrations.Kingdom do
  use Ecto.Migration

  def change do
    create table(:kingdom, primary_key: false) do
      add :kingdom_id, :integer, primary_key: true
      add :story_id, :integer
      add :avatar_url, :string

      timestamps()
    end
  end
end
