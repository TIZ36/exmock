defmodule KingdomPo do
  use Ezx.Orm.Model

  model Kingdom,
        fields: (
          field :kingdom_id, :integer, primary_key: true
          field :story_id, :integer
          field :avatar_url, :string

          timestamps()
          )
end