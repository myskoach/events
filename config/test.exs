use Mix.Config

config :logger, level: :warn

config :forum,
  pub_sub: Forum.PubSub.MockPubSub,
  consumers: [Forum.TestConsumer]

config :forum, Forum.PubSub.PhoenixPubSub,
  server: :some_server
