defmodule Exmock.Common.ErrorCode do
  @moduledoc false
  defmacro __using__(_version) do
    quote do
      import unquote(__MODULE__)
      use Ezx.Common.Norm

      @ok code(996, msg: "ok")
      @unknown_err code(999, msg: "unknown err")
      @ecode_not_found code(1000, msg: "can not found")
      @ecode_db_error code(2000, msg: "db error")
      @ecode_internal_err code(500, msg: "internal error")

      @ecode_dup_req code(501, msg: "duplicated request")
      @ecode_service_reject code(502, msg: "service reject")
    end
  end

  defmacro ok(data: data) do
    quote do
      %{
        service: @ok,
        data: unquote(data)
      }
    end
  end


  defmacro fail(err_code, data: data) do
    quote do
      %{
        service: unquote(err_code),
        data: unquote(data)
      }
    end
  end

  defmacro fail(err_code) do
    quote do
      fail(unquote(err_code), data: %{})
    end
  end
end
