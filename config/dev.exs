import Config

# config mysql
config :exmock, Exmock.Repo,
       database: "game_mock",
       username: "root",
       password: "0310",
       hostname: "127.0.0.1",
       port: 3306,
       pool_size: 10,
       show_sensitive_data_on_connection_error: true

# maru config
config :exmock, Exmock.Server,
       adapter: Plug.Adapters.Cowboy,
       plug: Exmock.Router,
       scheme: :http,
       bind_addr: "0.0.0.0",
       port: 8765


config :exmock, Exmock.EtsCache,
       primary: [
         gc_interval: :timer.hours(12),
         backend: :shards,
         partitions: 2
       ]

config :exmock, Exmock.RedisCache,
       conn_opts: [
         host: "127.0.0.1",
         password: "123456",
         port: 6379
       ]
