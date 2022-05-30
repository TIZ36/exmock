defmodule GroupPo do
  use Ezx.Orm.Model

  model Group,
        fields: (
          field :group_id, :integer, primary_key: true
          field :group_name, :string
          field :group_avatar, :string
          field :group_type, :integer
          field :group_sub_type, :integer

          timestamps()
          )
end