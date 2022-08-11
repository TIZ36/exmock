defmodule Exmock.GearApi do
  use Maru.Router
  use Exmock.Common.ErrorCode
  alias Exmock.Service.Gear, as: GearService

  require Ezx.Util
  require Logger

  @doc """
  定义分发的service入口
  """
  def dispatch_get("user", api, params) do
    Ezx.Util.no_panic "user.#{api}: params: #{inspect(params)}", fallback: @ecode_internal_err do
      UserService.get(api, params)
    end
  end

  post "api/v1/uniswf/scan/image" do
    Process.sleep(1000)

    conn
    |> put_status(200)
    |> json(%{})
  end
end