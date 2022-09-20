defmodule Exmock.App do
  use Application

  @impl true
  def start(_, _) do
    IMCommon.HttpUtils.init()
    children = [
#      {Exmock.EtsCache, []},
     {Exmock.EtsCache, []},
     {Exmock.RedisCache, []},

      # mysql repo
      {Exmock.Repo, []},
      # maru server
      {Exmock.Server, []},

      # supervisors
      Exmock.Service.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
