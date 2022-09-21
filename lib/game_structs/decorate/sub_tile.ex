defmodule Subtitle do
  @moduledoc """
  subtile 数据结构定义
  """
  @derive Jason.Encoder
  defstruct key: "", content: "", bg_url: ""
end
