defmodule Exmock.Repo.Migrations.Test do
  use Ecto.Migration

  def change do
    create table(:test, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
