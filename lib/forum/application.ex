defmodule Forum.Application do
  use Application

  def start(_type, _args) do
    children = [
      Forum.ConsumerSupervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Forum.Supervisor)
  end
end
