import Config

config :exmock, ecto_repos: [Exmock.Repo]

# config mysql
config :exmock, Exmock.Repo,
  database: "game_mock",
  username: "root",
  password: "0310",
  hostname: "localhost",
  pool_size: 10,
  show_sensitive_data_on_connection_error: true

# maru config
config :exmock, Exmock.Server,
  adapter: Plug.Adapters.Cowboy,
  plug: Exmock.Router,
  scheme: :http,
  port: 8880

config :exmock,
  maru_servers: [Exmock.Server]

config :snowflake,
  mechine_id: 1,
  epoch: 1653903685676
