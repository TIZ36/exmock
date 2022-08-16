import Config

# config mysql
config :exmock, Exmock.Repo,
  database: "game_mock",
  username: "root",
  password: "zWsxYmAcoutCtaa6",
  hostname: "10.137.147.59",
  port: 3306,
  pool_size: 10,
  show_sensitive_data_on_connection_error: true

# maru config
config :exmock, Exmock.Server,
  adapter: Plug.Adapters.Cowboy,
  plug: Exmock.Router,
  scheme: :http,
  port: 8888
