defmodule Exmock.MixProject do
  use Mix.Project

  def project do
    [
      app: :exmock,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Exmock.App, [:permanent]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:maru, "~> 0.13.2"},
      {:plug_cowboy, "~> 2.3"},
      {:ecto_sql, "~> 3.0"},
      {:myxql, ">= 0.2.0"},

      # Optional dependency, you can also add your own json_library dependency
      # and config with `config :maru, json_library, YOUR_JSON_LIBRARY`.
      {:jason, "~> 1.1"},
      # for id generation
      {:snowflake, "~> 1.0"},

      # for fake data
      {:faker, "~> 0.17"},
      {:tesla, "~> 1.4"},

      # optional, but recommended adapter
      {:finch, "~> 0.3"},

      # cache
      {:nebulex, "~> 2.3.1"},
      {:shards, "~> 1.0"},
      {:decorator, "~> 1.4"},
      {:telemetry, "~> 1.0"},

      # redis
      {:nebulex_redis_adapter, "~> 2.2.0"}
#      {:crc, "~> 0.10"},    #=> Needed when using Redis Cluster
#      {:jchash, "~> 0.1.2"} #=> Needed when using consistent-hashing
    ]
  end
end
