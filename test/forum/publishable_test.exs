defmodule Forum.PublishableTest do
  use ExUnit.Case, async: true

  alias Forum.Publishable

  describe "topic/1" do
    test "returns the topic for the event by default" do
      assert Publishable.topic(%Forum.TestEventOne{life: 42}) == "test-event-one"
    end
  end
end
