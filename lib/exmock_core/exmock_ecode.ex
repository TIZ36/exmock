defmodule Exmock.ErrorCode do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      alias unquote(__MODULE__)

      import Exmock.NPR

      @ok ecode(code: 200, err_msg: "success")
      @unknown_err ecode(code: 999, err_msg: "unknown err")
      @ecode_not_found ecode(code: 1000, err_msg: "can not found")
      @ecode_db_error ecode(code: 2000, err_msg: "db error")
      @ecode_internal_err ecode(code: 500, err_msg: "internal error")

      @ecode_dup_req ecode(code: 501, err_msg: "duplicated request")
      @ecode_service_reject ecode(code: 502, err_msg: "service reject")
    end
  end
end
