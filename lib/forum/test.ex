defmodule Forum.Test do
  @moduledoc """
  # `Forum.Test`

  Helper functions for testing modules using Forum.
  """

  @doc """
  Publishes the given event directly to a consumer. Useful for unit testing
  consumer functions.
  """
  @spec publish(Map.t, module) :: :ok | {:error, any}
  def publish(%{__struct__: event_name} = event, consumer) do
    try do
      case consumer.handle_info({event_name.topic(), event}, nil) do
        {:noreply, _} -> :ok
        error -> error
      end
    rescue
      _ in FunctionClauseError ->
        message = "The given consumer (#{inspect consumer}) cannot handle event #{inspect event}"
        {:error, message}
    end
  end

  @doc """
  Same as `publish/2` but raises on error.
  """
  @spec publish!(Map.t, module) :: nil
  def publish!(event, consumer) do
    case publish(event, consumer) do
      :ok -> nil
      {:error, error} -> raise error
    end
  end
end
