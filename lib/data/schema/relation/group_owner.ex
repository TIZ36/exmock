defmodule Exmock.Data.Schema.GroupOwner do
  @moduledoc false
  use Ecto.Schema

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key false
  schema "group_owner" do
    field :group_id, :integer, primary_key: true
    field :group_owners, :binary

    timestamps()
  end

  def changeset(group_owner, attrs) do
    group_owner
    |> Ecto.Changeset.cast(attrs, [:group_id, :group_owners])
    |> Ecto.Changeset.validate_required([:group_id, :group_owners])
  end
end
