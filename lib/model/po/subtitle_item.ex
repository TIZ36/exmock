defmodule SubTitleItemPo do
  use Ezx.Orm.Model

  model SubTitleItem,
        fields: (
          field :key, :string
          field :content, :string
          field :bg_url, :string
          field :user_info_uid, :integer, primary_key: true

          timestamps()
          )
end