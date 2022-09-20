defmodule Exmock.Data.Schema.UserBlacklist do
  @moduledoc """
  黑名单逻辑
  | -   one_uid[主]   - | -     ano_uid    - | -   relate_hash[p]- | -   black_state   - |
  |-------------------- |--------------------|---------------------|---------------------|
  | :integer            | :integer           | :string             | :integer            |


  black_state:  1 拉黑， 0 未拉黑
  """
  use Ecto.Schema

  @derive {Jason.Encoder, except: [:__meta__]}

  @primary_key false
  schema "user_blacklist" do
    field :one_uid, :integer
    field :ano_uid, :integer
    field :relate_hash, :string, primary_key: true
    field :black_state, :integer

    timestamps()
  end

  def changeset(user_black, %{one_uid: one_uid, ano_uid: ano_uid, black_state: bls} = attrs) do
    attrs2 = Map.put(attrs, :relate_hash, relate_hash(one_uid, ano_uid))

    user_black
    |> Ecto.Changeset.cast(attrs2, [:one_uid, :ano_uid, :relate_hash, :black_state])
    |> Ecto.Changeset.validate_required([:one_uid, :ano_uid, :relate_hash, :black_state])
  end

  def update_changeset(user_black, attrs) do
    user_black
    |> Ecto.Changeset.cast(attrs, [:one_uid, :ano_uid, :relate_hash, :black_state])
    |> Ecto.Changeset.validate_required([:one_uid, :ano_uid, :black_state])
  end

  @doc """
  可以快速找到双方的记录，查看对方是否拉黑自己
  """
  def relate_hash(one_uid, ano_uid) do
    concat =
      if one_uid < ano_uid do
        "bl-#{one_uid}-#{ano_uid}"
      else
        "bl-#{ano_uid}-#{one_uid}"
      end

    :crypto.hash(:md5, concat) |> Base.encode16()
  end
end