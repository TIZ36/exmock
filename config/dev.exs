import Config

# config mysql
config :exmock, Exmock.Repo,
  database: "game_mock",
  username: "lilithop",
  password: "Lilith_301",
  hostname: "rm-uf6i5p2d2b9h2acnm.mysql.rds.aliyuncs.com",
  port: 3306,
  pool_size: 10,
  show_sensitive_data_on_connection_error: true

# maru config
config :exmock, Exmock.Server,
  adapter: Plug.Adapters.Cowboy,
  plug: Exmock.Router,
  scheme: :http,
  port: 8880


config :exmock, Exmock.EtsCache,
  primary: [
    gc_interval: :timer.hours(12),
    backend: :shards,
    partitions: 2
  ]

config :exmock, Exmock.RedisCache,
  conn_opts: [
    host: "r-uf63x26gecho6stbtk.redis.rds.aliyuncs.com",
    password: "iKCbzbffKxGB60Hxmbc",
    port: 6379
  ]
