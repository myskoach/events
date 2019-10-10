defmodule Forum.ConsumerTest do
  use ExUnit.Case, async: true

  import Mimic

  setup :verify_on_exit!

  describe "__using__" do
    defmodule Forum.TestUsingConsumer do
      use Elixir.Forum.Consumer
      consume Elixir.Forum.TestEventOne, _, do: :ok
      consume Elixir.Forum.TestEventTwo, _, do: :ok
    end

    test "defines a `subscribe_topics` function that subscribes to all topics that are consumed" do
      Elixir.Forum.PubSub.MockPubSub
      |> expect(:subscribe, 2, fn
        "test-event-one" -> :ok
        "test-event-two" -> :ok
      end)

      assert Forum.TestUsingConsumer.subscribe_topics() == :ok
    end

    test "defines an `init` function that subscribes all topics and returns a valid gen-server response" do
      Elixir.Forum.PubSub.MockPubSub
      |> expect(:subscribe, 2, fn
        "test-event-one" -> :ok
        "test-event-two" -> :ok
      end)

      assert Forum.TestUsingConsumer.init(nil) == {:ok, nil}
    end
  end

  describe "consume/3" do
    defmodule Forum.TestConsumeConsumer do
      use Elixir.Forum.Consumer
      use Agent

      consume Elixir.Forum.TestEventOne, %{life: life, pid: pid} do
        Agent.update(pid, fn calls -> calls + life end)
      end

      def start_link(init), do: Agent.start_link(fn -> init end)
      def get_calls(pid), do: Agent.get(pid, fn calls -> calls end)
    end

    test "defines a `handle_info` callback that handles the consumed topic" do
      {:ok, pid} = Forum.TestConsumeConsumer.start_link(0)

      assert Forum.TestConsumeConsumer.handle_info({"test-event-one", %{pid: pid, life: 42}}, nil)
        == {:noreply, nil}

      assert Forum.TestConsumeConsumer.get_calls(pid) == 42

      assert Forum.TestConsumeConsumer.handle_info({"test-event-one", %{pid: pid, life: 42}}, nil)
        == {:noreply, nil}

      assert Forum.TestConsumeConsumer.get_calls(pid) == 84

      assert_raise FunctionClauseError,
        fn -> Forum.TestConsumeConsumer.handle_info({"test-event-two", %{pid: pid, life: 42}}, nil) end
    end
  end
end
