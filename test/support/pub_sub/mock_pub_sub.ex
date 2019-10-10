defmodule Forum.PubSub.MockPubSub do
  @behaviour Forum.PubSub

  @impl true
  @spec publish(String.t, Map.t) :: :ok | {:error, term}
  def publish(topic, _payload) do
    if topic == "fail" do
      {:error, :fail}
    else
      :ok
    end
  end

  @impl true
  @spec subscribe(String.t) :: :ok | {:error, term}
  def subscribe(topic) do
    if topic == "fail" do
      {:error, :fail}
    else
      :ok
    end
  end
end
