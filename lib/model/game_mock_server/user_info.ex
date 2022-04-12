defmodule Exmock.Model.GameMockServer.UserInfo do
  use Ecto.Schema
  import Ecto.Query, warn: false

  @primary_key false
  schema "user_info" do
    field(:id, :integer, primary_key: true)
    field(:data, :binary)

    timestamps()
  end

  def query_user(uid) do
    query =
      from user in "user_info",
        where: user.id == ^uid,
        select: %{
          id: user.id,
          data: user.data
        }

      Exmock.Repo.one(query)
  end

  def insert_user_info(id, data_bin) do
    changeset = %__MODULE__{id: id, data: data_bin}
    Exmock.Repo.insert(changeset)
  end

  def insert_user_info(%{id: id, data: data_bin} = _user_info) do
    insert_user_info(id, data_bin)
  end
end
