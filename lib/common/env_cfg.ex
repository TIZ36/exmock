defmodule Exmock.EnvCfg do

  @moduledoc false
    def get_at!() do
      System.get_env("access_type")
      |> Kernel.||("122")
      |> String.to_integer()
    end
end
