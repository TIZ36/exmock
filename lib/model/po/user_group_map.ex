defmodule UserGroupMapPo do
  use Ezx.Orm.Model
  model UserGroupMap,
        fields: (
          field :uid, :integer, primary_key: true
          field :gid, :integer, primary_key: true

          timestamps()
          )
end