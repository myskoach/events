defmodule Forum.Event do
  @callback topic() :: String.t
  @callback topic(struct) :: String.t

  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour Forum.Event

      @impl Forum.Event
      @spec topic() :: String.t
      def topic, do: __MODULE__ |> Module.split() |> List.last() |> Swiss.String.kebab_case()

      @impl Forum.Event
      @spec topic(struct) :: String.t
      def topic(_struct), do: topic() # TODO we can use the protocol for the struct here instead of an override

      defoverridable topic: 0, topic: 1
    end
  end
end
