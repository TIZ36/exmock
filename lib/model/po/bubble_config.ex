defmodule BubbleConfigPo do
  use Ezx.Orm.Model

  model BubbleConfig,
        fields: (
          field :left_normal, :map
          field :left_pressed, :map
          field :right_normal, :map
          field :right_pressed, :map
          field :user_info_uid, :integer, primary_key: true

          timestamps()
          )
end