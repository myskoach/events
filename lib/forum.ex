defmodule Forum do
  @moduledoc """
  # Forum

  Forum is a lib with a friendly DSL for declaring PubSub systems. It was
  designed to be a wrapper over multiple back-ends.

  Forum is a work in progress.
  """
  alias Forum.{PublishError, SubscribeError}

  @pub_sub Application.get_env(:forum, :pub_sub)

  @doc """
  Publishes the given event to the pub_sub system.
  """
  @spec publish(struct) :: :ok | {:error, term}
  def publish(%{__struct__: event_name} = event) do
    topic = event_name.topic(event)
    @pub_sub.publish topic, {topic, event}
  end

  @doc """
  Publishes the given event to the pub_sub system, raises on failures.
  """
  @spec publish!(struct) :: :ok
  def publish!(event) do
    case publish(event) do
      :ok -> :ok
      error -> raise PublishError, error
    end
  end

  @doc """
  Subscribes the calling process to the given topic using the pub_sub system.
  """
  @spec subscribe(String.t) :: :ok | {:error, term}
  def subscribe(topic) do
    @pub_sub.subscribe topic
  end

  @doc """
  Subscribes the calling process to the given topic using the pub_sub system,
  raising on errors.
  """
  @spec subscribe!(String.t) :: :ok
  def subscribe!(topic) do
    case subscribe(topic) do
      :ok -> :ok
      error -> raise SubscribeError, error
    end
  end
end
