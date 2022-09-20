defmodule Exmock.Data.Schema.UserBasicInfo do
  use Ecto.Schema

  @primary_key false
  schema "basic_info" do
    field :uid, :integer, primary_key: true
    field :cur_stage, :integer
    field :maincity_level, :integer

    timestamps()
  end

  def changeset(user_basicinfo, attrs) do
    user_basicinfo
    |> Ecto.Changeset.cast(attrs, [:uid, :cur_stage, :maincity_level])
    |> Ecto.Changeset.validate_required([:uid, :cur_stage, :maincity_level])
  end

  def update_changeset(user_basicinfo, attrs) do
    user_basicinfo
    |> Ecto.Changeset.cast(attrs, [:uid, :cur_stage, :maincity_level])
    |> Ecto.Changeset.validate_required([:uid])
  end
end