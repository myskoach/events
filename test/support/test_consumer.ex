defmodule Forum.TestConsumer do
  use Forum.Consumer

  consume Forum.TestEventOne, %{life: life} do
    Forum.TestConsumerImpl.test_event(life)
  end
end

defmodule Forum.TestConsumerImpl do
  # For mocking only
  def test_event(_life), do: :ok
end
