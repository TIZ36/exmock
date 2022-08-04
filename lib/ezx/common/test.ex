defmodule CassPerform do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      alias unquote(__MODULE__)
      import Kernel, except: [def: 2]
      @on_definition {CassAnnotate, :on_definition}

      Module.register_attribute(__MODULE__, :params, accumulate: true)
      Module.register_attribute(__MODULE__, :time_consume_cals, accumulate: true)
      Module.register_attribute(__MODULE__, :show_mes, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro def(func_p1, [{:add_on, add_ons}], do: block) do
    quote do
      Kernel.def(unquote(func_p1),
        do:
          (
            IO.inspect(unquote(add_ons))
            unquote(block)
          )
      )
    end
  end

  defmacro def(func_p1, do: block) do
    {func_name, _, _} = func_p1

    quote do
      require Logger

      Kernel.def(
        unquote(func_p1),
        do:
          (
            case params(unquote(func_name)) do
              nil ->
                IO.inspect("no params limit")

              other ->
                IO.inspect(other, label: "#{unquote(func_name)}")
            end

            if time_consume_cal?(unquote(func_name)) do
              start_time = :erlang.system_time(1000)
              re = unquote(block)
              end_time = :erlang.system_time(1000)

              IO.inspect(
                "func: #{unquote(func_name)} input: #{inspect(binding())} consume time: #{end_time - start_time}",
                label: "==== after func ===="
              )

              re
            else
              unquote(block)
            end
          )
      )
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def params(key) do
        case Keyword.get(@params, key, nil) do
          nil ->
            nil

          config ->
            config
        end
      end

      def time_consume_cal?(key) do
        case Keyword.get(@time_consume_cals, key, nil) do
          nil ->
            false

          _ ->
            true
        end
      end

      def show_me?(key) do
        case Keyword.get(@show_mes, key, nil) do
          nil ->
            false

          _ ->
            true
        end
      end
    end
  end

  defmacro ex_routine(func) do
    quote do
      spawn(fn -> unquote(func) end)
    end
  end
end

defmodule ZZ do
  use CassPerform

  @show_me true
  @time_consume_cal true
  @param [
    uid: {:required, :integer, 0},
    age: {:required, :integer, 12}
  ]
  @before_action {Action.Builder, :build_add_on, ["jack", 30]}
  def a(input), add_on: add_ons do
    IO.inspect(add_ons)
    Process.sleep(1000)
    input
  end

  @show_me true
  @time_consume_cal true
  def b(a, b), add_on: 1 do
    ex_routine(print([1, 2, 3, 4, 5]))
    a + b
    IO.inspect("end of b")
  end

  def print(n) do
    Enum.each(
      n,
      fn v ->
        Process.sleep(300)
        IO.inspect(v)
      end
    )
  end
end
