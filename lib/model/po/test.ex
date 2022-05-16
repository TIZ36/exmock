defmodule TestPo do
  use Ezx.Orm.Model

  model Test,
        fields: (
          field :id, :integer, primary_key: true
          field :name, :string

          timestamps()
          )
end