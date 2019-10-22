defmodule Forum.PubSub.PhoenixPubSub do
  @moduledoc """
  Defines an `Forum.PubSub` implementation using `Phoenix.PubSub`. Use this
  module by specifying it as the pub_sub wrapper in config:

      config :forum, pub_sub: Forum.PubSub.PhoenixPubSub

  You'll also need to specify which PubSub server to use:

      config :forum, Forum.PubSub.PhoenixPubSub,
        server: MyApp.PubSub

  More about what the server is and how to config it in the `Phoenix.PubSub`
  [docs](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html).
  """

  require Logger

  @behaviour Forum.PubSub

  @phoenix_pub_sub Application.get_env(:forum, __MODULE__)

  @impl true
  @spec publish(String.t, Map.t) :: :ok | {:error, term}
  def publish(topic, payload) do
    Logger.debug(
      "[PhoenixPubSub] Broadcasting on topic #{inspect topic}",
      [server: server(), payload: payload]
    )

    Phoenix.PubSub.broadcast(server(), topic, payload)
  end

  @impl true
  @spec subscribe(String.t) :: :ok | {:error, term}
  def subscribe(topic) do
    Logger.debug(
      "[PhoenixPubSub] Subscribing to topic #{inspect topic}",
      [server: server()]
    )

    Phoenix.PubSub.subscribe(server(), topic)
  end

  defp server() do
    if is_nil(@phoenix_pub_sub), do: raise "No config for `phoenix_pub_sub` provided"

    case Keyword.fetch(@phoenix_pub_sub, :server) do
      {:ok, server} -> server
      :error -> raise "No server name configured for `phoenix_pub_sub`"
    end
  end
end
