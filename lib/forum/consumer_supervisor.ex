defmodule Forum.ConsumerSupervisor do
  require Logger

  use Supervisor

  @consumers Application.get_env(:forum, :consumers, [])

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    if @consumers == [] do
      Logger.warn("[Forum.ConsumerSupervisor] No consumers detected. Did you forget to config?")
    end

    @consumers
    |> Enum.map(fn consumer -> %{
      id: consumer,
      start: {GenServer, :start_link, [consumer, nil]}
    } end)
    |> Supervisor.init(strategy: :one_for_one)
  end
end
