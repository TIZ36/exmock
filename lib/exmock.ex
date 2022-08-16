defmodule Exmock.App do
  use Application

  @impl true
  def start(_, _) do
    IMCommon.HttpUtils.init()
    children = [
      # mysql repo
      {Exmock.Repo, []},
      # maru server
      {Exmock.Server, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
