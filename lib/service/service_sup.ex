defmodule Exmock.Service.Supervisor do
  use Supervisor

  def start_link(init_args) do
    Supervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def init(_init_args) do
    children = [
      Exmock.Service.Friend
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end