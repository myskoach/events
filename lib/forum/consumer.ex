defmodule Forum.Consumer do
  defmacro __using__(_opts) do
    quote do
      use GenServer
      import unquote(__MODULE__)

      @before_compile unquote(__MODULE__)
      @topics []

      def init(_) do
        case __MODULE__.subscribe_topics() do
          :ok -> {:ok, nil}
          error -> error
        end
      end
    end
  end

  defmacro consume(event_module, message, do: block) do
    message = Macro.escape(message)
    block = Macro.escape(block)
    topic = Macro.expand(event_module, __CALLER__).topic() # TODO topic args

    quote location: :keep, bind_quoted: [topic: topic, message: message, block: block] do
      @topics [topic | @topics]

      def handle_info({unquote(topic), unquote(message)}, state) do
        unquote(block)
        {:noreply, state}
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @topics Enum.uniq(@topics)

      def subscribe_topics() do
        Enum.reduce_while(@topics, :ok, fn topic, _ ->
          case Forum.subscribe(topic) do
            :ok -> {:cont, :ok}
            error -> {:halt, error}
          end
        end)
      end
    end
  end
end
