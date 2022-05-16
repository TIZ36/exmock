defmodule GroupInfoPo do
  use Ezx.Orm.Model

  model GroupInfo,
        fields: (
          field :id, :integer, primary_key: true
          field :data, :binary

          timestamps()
          )
end