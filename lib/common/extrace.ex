defmodule Extrace do
  @moduledoc """
  for a simple tracer
  """

  require Logger

  @one_second 1_000
  @default_trace_config %{
    # 不设置就是5分钟结束
    expire: 300
  }

  @default_trace_target :all
  @default_trace_flag [:timestamp, :c]

  @doc """
  开始trace吧
  """
  def start(%{expire: expire} = config \\ @default_trace_config) do
    case :dbg.get_tracer() do
      {:error, _} ->
        {:ok, _} = :dbg.tracer(:process, {&__MODULE__.on_trace_msg/2, config})

        :timer.apply_after(expire * @one_second, :dbg, :stop_clear, [])

        :dbg.p(@default_trace_target, @default_trace_flag)

      {:ok, _} ->
        Logger.warn("dbg is already started, do not retart")
        {:error, :already_running}
    end
  end


  def on_trace_msg(
        {
          _tt,
          pid,
          tag,
          {module, func, args},
          msg,
          tss
        } = info,
        _config
      ) do
    time_str = get_time_str(tss)

    case tag do
      :call ->
        my_put(
          "#{time_str} | #{inspect(pid)} | call ~>",
          {module, func, args},
          :white,
          :blue
        )

      :return_from ->
        my_put(
          "#{time_str} | #{inspect(pid)} | resp ~>",
          msg,
          :white,
          :yellow
        )
      :exception_from ->
        my_put(
          "#{time_str} | #{inspect(pid)} | resp ~>",
          msg,
          :red_background,
          :blue
        )

      _ ->
        IO.inspect(info)
    end
  end

  def my_put(tag, msg, bg_color, color) when is_binary(msg) do
    IO.puts(IO.ANSI.format([bg_color, color, inspect(tag)]))
    IO.puts(Jason.Formatter.pretty_print(msg))
  end

  def my_put(tag, msg, bg_color, color) do
    my_inspect(tag, msg, bg_color, color)
  end

  def my_inspect(tag, msg, bg_color, color) do
    IO.inspect(msg, label: IO.ANSI.format([bg_color, color, inspect(tag)]))
  end

  def get_time_str({ts1, ts2, ts3}) do
    get_time_str(ts1, ts2, ts3)
  end

  def get_time_str(ts1, ts2, ts3) do
    v = DateTime.from_unix!(ts1 * 1_000_000 + ts2, :second) |> to_string()
    "#{v}~#{ts3}"
  end
end
