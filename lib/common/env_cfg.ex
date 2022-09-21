defmodule Exmock.EnvCfg do

  @moduledoc false
    def get_at!() do
      System.get_env("access_type") |> String.to_integer()
    end
end
