#defmodule TestMapper do
#  use Ezx.Orm.Mapper
#  import Ecto.Query, warn: false
#
#  # orMapper to insert into db
#  mapper "insert_test_by_id", validator: &__MODULE__.validate_insert_test_by_id/1, params: %TestPo.Test{} = po do
#    Exmock.Repo.insert(po)
#  end
#
#  mapper "insert_test_by_id_no", params: %TestPo.Test{} = po do
#    Exmock.Repo.insert(po)
#  end
#
#  def validate_insert_test_by_id(%TestPo.Test{} = input) do
#    IO.inspect(input, label: "do validate")
#    false
#  end
#end