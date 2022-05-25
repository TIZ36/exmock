defmodule UserBasicInfoPo do
  use Ezx.Orm.Model

  model UserBasicInfo,
        fields: (
          field :uid, :integer, primary_key: true
          field :cur_stage, :integer
          field :maincity_level, :integer

          timestamps()
          )

end