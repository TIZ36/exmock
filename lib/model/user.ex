defmodule User do
  use Ezx.Orm.Model

  model BasicInfo,
        fields: (
          field :uid, :integer, primary_key: true
          field :cur_stage, :integer
          field :maincity_level, :integer

          timestamps()
          )

  model UserInfo,
        [
          fields: (
            field :uid, :integer, primary_key: true
            field :data, :binary

            timestamps()
            )
        ],
        %UserInfoStruct{}
end