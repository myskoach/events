use Mix.Config

config :forum,
  pub_sub: Forum.PubSub.MockPubSub,
  consumers: [Forum.TestConsumer]

config :forum, Forum.PubSub.PhoenixPubSub,
  server: :some_server
