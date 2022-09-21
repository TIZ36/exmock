defmodule Exmock.Data.Schema.UserFriend do
  @moduledoc false
  use Ecto.Schema

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key false
  schema "user_friend" do
    field :one_uid, :integer
    field :ano_uid, :integer
    field :relate_hash, :string, primary_key: true

    timestamps()
  end

  def changeset(user_friend, %{one_uid: one_uid, ano_uid: ano_uid} = attrs) do
    attrs2 = Map.put(attrs, :relate_hash, relate_hash(one_uid, ano_uid))

    user_friend
    |> Ecto.Changeset.cast(attrs2, [:one_uid, :ano_uid, :relate_hash])
    |> Ecto.Changeset.validate_required([:one_uid, :ano_uid, :relate_hash])
  end


  def relate_hash(one_uid, ano_uid) do
    concat =
      if one_uid < ano_uid do
        "fri-#{one_uid}-#{ano_uid}"
      else
        "fri-#{ano_uid}-#{one_uid}"
      end

    :crypto.hash(:md5, concat) |> Base.encode16()
  end
end
