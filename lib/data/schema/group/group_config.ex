defmodule Exmock.Data.Schema.GroupConfig do
  @moduledoc false
  use Ecto.Schema

  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key false
  schema "group_config" do
    field :group_id, :integer, primary_key: true
    field :positions, :binary

    timestamps()
  end

  def new_changeset(group_config, attrs) do
    group_config
    |> Ecto.Changeset.cast(attrs, [
      :group_id,
      :positions
    ])
    |> Ecto.Changeset.validate_required([
      :group_id,
      :postions
    ])
  end

  def update_changeset(group_config, attrs) do
    group_config
    |> Ecto.Changeset.cast(attrs, [
      :group_id,
      :positions
    ])
    |> Ecto.Changeset.validate_required([
      :group_id,
      :postions
    ])
  end
end
