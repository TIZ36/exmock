defmodule UserInfoPo do
  use Ezx.Orm.Model

  model UserInfo,
        fields: (
          field :id, :integer, primary_key: true
          field :data, :binary

          timestamps()
          )

end