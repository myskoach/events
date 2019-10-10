defmodule Forum.PubSub do
  @callback publish(topic :: String.t, payload :: Map.t) :: :ok | {:error, term}
  @callback subscribe(topic :: String.t) :: :ok | {:error, term}
end
