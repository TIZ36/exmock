defmodule Exmock.Data.Schema.GroupInfo do
  @moduledoc false
  use Ecto.Schema

  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key false
  schema "group_info" do
    field(:group_id, :integer, primary_key: true)
    field(:group_name, :string)
    field(:group_avatar, :string)
    # 1: group 2: room
    field(:group_type, :integer)
    field(:group_sub_type, :integer)
    field(:server_id, :string)
    field(:manager_list, :binary)
    # 每天最多@人的次数
    field(:at_all_per_day, :integer)

    timestamps()
  end

  def changeset(group_info, attrs) do
    group_info
    |> Ecto.Changeset.cast(attrs, [
      :group_id,
      :group_name,
      :group_avatar,
      :group_type,
      :group_sub_type,
      :server_id,
      :manager_list,
      :at_all_per_day
    ])
    |> Ecto.Changeset.validate_required([
      :group_id,
      :group_name,
      :group_avatar,
      :group_type,
      :group_sub_type,
      :server_id
    ])
  end

  def update_changeset(group_info, update_attrs) do
    group_info
    |> Ecto.Changeset.cast(update_attrs, [
      :group_id,
      :group_name,
      :group_avatar,
      :group_type,
      :group_sub_type,
      :server_id,
      :manager_list,
      :at_all_per_day
    ])
    |> Ecto.Changeset.validate_required([
      :group_id
    ])
  end
end
