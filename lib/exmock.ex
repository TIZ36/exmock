defmodule Exmock.App do
  @moduledoc false
  use Application

  @impl true
  def start(_, _) do
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
