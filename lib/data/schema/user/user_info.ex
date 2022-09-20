defmodule Exmock.Data.Schema.UserInfo do
  use Ecto.Schema

  @primary_key false
  schema "user_info" do
    field(:uid, :integer, primary_key: true)
    field(:data, :binary)

    timestamps()
  end

  def changeset(user_info, attrs) do
    user_info
    |> Ecto.Changeset.cast(attrs, [:uid, :data])
    |> Ecto.Changeset.validate_required([:uid, :data])
  end
end