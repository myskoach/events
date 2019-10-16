defmodule Forum.TestTest do
  use ExUnit.Case, async: true

  describe "publish/2" do
    test "simulates the given event on the given consumer module" do
      assert Forum.Test.publish(%Forum.TestEventOne{life: 42}, Forum.TestConsumer) == :ok
    end

    test "returns an error when the consumer cannot handle the event" do
      {:error, error} = Forum.Test.publish %Forum.TestEventTwo{question: 42}, Forum.TestConsumer
      assert error =~ ~r/cannot handle event/
    end
  end

  describe "publish!/2" do
    test "raises an error when the consumer cannot handle the event" do
      assert_raise(RuntimeError, ~r/cannot handle event/, fn ->
        Forum.Test.publish! %Forum.TestEventTwo{question: 42}, Forum.TestConsumer
      end)
    end
  end
end
