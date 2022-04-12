import Config

config :exmock, Exmock.Server,
  adapter: Plug.Adapters.Cowboy,
  plug: Exmock.Router,
  scheme: :http,
  port: 8880

config :exmock,
  maru_servers: [Exmock.Server]
