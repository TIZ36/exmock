import Config

import_config "#{config_env()}.exs"

config :exmock, ecto_repos: [Exmock.Repo]

config :exmock,
  maru_servers: [Exmock.Server]

config :snowflake,
  mechine_id: 1,
  epoch: 1_653_903_685_676

config :tesla, :adapter, {Tesla.Adapter.Finch, name: ExmockFinch}
