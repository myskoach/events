defmodule ForumTest do
  use ExUnit.Case, async: true
  doctest Forum

  import Mimic

  setup :verify_on_exit!

  describe "publish/2" do
    test "publishes the given event in the configured pub-sub" do
      Forum.PubSub.MockPubSub
      |> expect(:publish, fn "test-event-one", {"test-event-one", %{life: 42}} -> :ok end)

      assert Forum.publish(Forum.TestEventOne.new(42)) == :ok
    end

    test "fails if the publishing fails" do
      Forum.PubSub.MockPubSub
      |> expect(:publish, fn "test-event-one", {"test-event-one", %{life: 42}} -> {:error, :fail} end)

      assert Forum.publish(Forum.TestEventOne.new(42)) == {:error, :fail}
    end
  end

  describe "subscribe/1" do
    test "subscribes to the given topic via the configured pub-sub" do
      Forum.PubSub.MockPubSub
      |> expect(:subscribe, fn "test-topic" -> :ok end)

      assert Forum.subscribe("test-topic") == :ok
    end

    test "fails if the subscription fails" do
      Forum.PubSub.MockPubSub
      |> expect(:subscribe, fn "test-topic" -> {:error, :oops} end)

      assert Forum.subscribe("test-topic") == {:error, :oops}
    end
  end
end
