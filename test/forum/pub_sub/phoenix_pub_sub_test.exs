defmodule Forum.PubSub.PhoenixPubSubTest do
  use ExUnit.Case, async: true

  import Mimic

  alias Forum.PubSub.PhoenixPubSub

  setup :verify_on_exit!

  describe "publish/2" do
    test "calls the Phoenix.PubSub broadcast function with the configured server" do
      Phoenix.PubSub
      |> expect(:broadcast, fn server_name, "test-event", %{life: 42} ->
        assert server_name ==
          Application.get_env(:forum, Forum.PubSub.PhoenixPubSub) |> Keyword.fetch!(:server)
        :ok
      end)

      assert PhoenixPubSub.publish("test-event", %{life: 42}) == :ok
    end
  end

  describe "subscribe/1" do
    test "calls the Phoenix.PubSub subscribe function with the configured server" do
      Phoenix.PubSub
      |> expect(:subscribe, fn server_name, "test-event" ->
        assert server_name ==
          Application.get_env(:forum, Forum.PubSub.PhoenixPubSub) |> Keyword.fetch!(:server)
        :ok
      end)

      assert PhoenixPubSub.subscribe("test-event") == :ok
    end
  end
end
