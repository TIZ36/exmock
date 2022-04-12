defmodule Exmock.Model.GameMockServer.GroupInfo do
  use Ecto.Schema
  import Ecto.Query, warn: false

  @primary_key false
  schema "group_info" do
    field(:id, :integer, primary_key: true)
    field(:data, :binary)

    timestamps()
  end

  def query_group(group_id) do
    query =
      from group_info in "group_info",
        where: group_info.id == ^group_id,
        select: %{
          group_id: group_info.id,
          group_data: group_info.data
        }

      Exmock.Repo.one(query)
  end

  def insert_group_info(id, data_bin) do
    changeset = %__MODULE__{id: id, data: data_bin}
    Exmock.Repo.insert(changeset)
  end

  def insert_group_info(%{id: id, data: data_bin} = _group_map) do
    insert_group_info(id, data_bin)
  end
end
