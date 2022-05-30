defmodule GroupMapper do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  mapper "create_group", params: %GroupPo.Group{} = po do
    Exmock.Repo.insert(po)
  end
end