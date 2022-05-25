defmodule GuildPo do
  use Ezx.Orm.Model

  model Guild,
        fields: (
          field :id, :integer, primary_key: true
          field :name, :string
          field :avatar_url, :string
          field :abbr_name, :string

          timestamps()
          )
end