defmodule Exmock.App do
  use Application

  @impl true
  def start(_, _) do
    children =
      [
        {Exmock.Server, []}
      ]

      Supervisor.start_link(children, strategy: :one_for_one)
  end
end
