defmodule Exmock.MixProject do
  use Mix.Project

  def project do
    [
      app: :exmock,
      version: "0.1.0",
      elixir: "~> 1.13",
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
      {:maru, "~> 0.13.2"},
      {:plug_cowboy, "~> 2.3"},
      {:ecto_sql, "~> 3.0"},
      {:myxql, ">= 0.2.0"},

      # Optional dependency, you can also add your own json_library dependency
      # and config with `config :maru, json_library, YOUR_JSON_LIBRARY`.
      {:jason, "~> 1.1"},
      # for id generation
      {:snowflake, "~> 1.0"}
    ]
  end
end
