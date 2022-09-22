defmodule Exmock.Data.Schema.UserGroupMapping do
  @moduledoc false
  use Ecto.Schema

  @primary_key false
  schema "user_group_mapping" do
    field :uid, :integer, primary_key: true
    field :group_id, :integer, primary_key: true

    timestamps()
  end

  @required_fields [:uid, :group_id]

  @doc """
  新建记录的changeset
  """
  def changeset(user_group_mapping, attrs) do
    user_group_mapping
    |> Ecto.Changeset.cast(attrs, @required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end
