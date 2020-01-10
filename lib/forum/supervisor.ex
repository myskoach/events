defmodule Forum.Supervisor do
  require Logger

  use Supervisor

  def start_link(consumers) do
    consumers = consumers || Application.get_env(:forum, :consumers, [])
    Supervisor.start_link(__MODULE__, consumers, name: __MODULE__)
  end

  @impl true
  def init(consumers) do
    if consumers == [] do
      Logger.warn("[Forum.ConsumerSupervisor] No consumers detected. Did you forget to config?")
    end

    consumers
    |> Enum.map(fn consumer -> %{
      id: consumer,
      start: {GenServer, :start_link, [consumer, nil]}
    } end)
    |> Supervisor.init(strategy: :one_for_one)
  end
end
