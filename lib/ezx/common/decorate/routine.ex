defmodule CassAnnotate do
  @moduledoc false
  @reserved_noun [:aspects, :inject_func, :time_consume_cal?]
  def on_definition(env, _access, name, _args, _guards, _body) do
    case Enum.member?(@reserved_noun, name) do
      true ->
        :skip

      false ->
        case Module.get_attribute(env.module, :param) do
          nil ->
            :skip

          v ->
            Module.put_attribute(env.module, :params, {name, v})
            Module.delete_attribute(env.module, :param)
        end

        case Module.get_attribute(env.module, :time_consume_cal) do
          nil ->
            :skip

          v ->
            Module.put_attribute(env.module, :time_consume_cals, {name, v})
            Module.delete_attribute(env.module, :time_consume_cal)
        end

        case Module.get_attribute(env.module, :show_me) do
          nil ->
            :skip

          v ->
            Module.put_attribute(env.module, :show_mes, {name, v})
            Module.delete_attribute(env.module, :show_me)
        end
    end
  end
end
