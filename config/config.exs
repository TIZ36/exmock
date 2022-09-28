import Config

base_config =  Path.join(["config", "#{config_env()}.exs"])
if File.exists?(base_config) do
  import_config "#{config_env()}.exs"
end

config :exmock, Exmock.EtsCache,
  # When using :shards as backend
  # backend: :shards,
  # GC interval for pushing new generation: 12 hrs
  gc_interval: :timer.hours(12),
  # Max 1 million entries in cache
  max_size: 1_000_000,
  # Max 2 GB of memory
  allocated_memory: 2_000_000_000,
  # GC min timeout: 10 sec
  gc_cleanup_min_timeout: :timer.seconds(10),
  # GC max timeout: 10 min
  gc_cleanup_max_timeout: :timer.minutes(10)

config :exmock, ecto_repos: [Exmock.Repo]

config :exmock,
  maru_servers: [Exmock.Server]

config :snowflake,
  mechine_id: 1,
  epoch: 1_653_903_685_676

config :tesla, :adapter, {Tesla.Adapter.Finch, name: ExmockFinch}
