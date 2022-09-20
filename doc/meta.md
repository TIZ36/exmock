# Elixir Meta Programming 的分享 

准则

1. 不要轻易写 ·宏·
2. 除非有极大的生产力提升

---

- AST(abstract syntax tree) `Every expression you write in Elixir breaks down to a three-element tuple din the AST`

```elixir
quote do: 1 + 2
```

---

- Macro 就是代码写代码，比如我们经常会使用到的关键字

![image-20220829200540452](/Users/lilithgame/Library/Application Support/typora-user-images/image-20220829200540452.png)

---
- 但是有些表达式不会被转化
```elixir
# atom
quote do: :ok

# integer
quote do: 1

# float
quote do: 3.3

# list
quote do: [1, 2]

# two-element tuple with types above
quote do: {1, [2, 3]}
```

---

- 宏在做的事情，其实就是在代码注入
```elixir
defmodule Mod do
  defmacro definfo do
    IO.puts "Macro's context #{__MODULE__}"

    quote do
      IO.puts "Caller's context #{__MODULE__}"

      def friendly_info do
        IO.puts """
        10 My name is #{__MODULE__}
        """
      end
    end
  end
end

defmodule Test do
	require Mod
	Mod.definfo
end

defmodule Meta do
  defmacro filter(condition, do: block) do
    quote do
      if unquote(condition) do
         unquote(block)
      else
         nil
      end
    end
  end
  defmacro transfer(keyword) do
    quote do
      %{unquote_splicing(keyword)}
    end
  end
end
  
  def test_filter(cond) do
    Meta.filter cond do
      IO.inspect("pass")
    end
  end
```
---
- 扩展模块

```
1. __using___(opts) + using
用上边两个组合可以接受参数，然后扩展模块代码

2. Module.register_attrubute(__MODULE__, :attr, accumulate: if_a_list)
使用注册模块变量可以在编译期做一些宏的数据聚合

3. import unquote(__MODULE__) alias unquote(__MODULE__)
用上边的语法可以让宏用起来比较好看

4. @before_compile + __before_compile__(env) [just before compilation is finished]
使用before_compile对你的宏编程做编译结束期的最终操作

5. @on_definition {module, func_name} [when compiler goes through fn]
可以在编译器拿到函数签名， 做一些更高级的代码注入

defmodule MyHttpServer do

  defmacro __using__(opts) do
    app_name = Keyword.get(opts, :otp_app, :im)

    quote do
      import Kernel, except: [def: 2]
      import unquote(__MODULE__)
      alias unquote(__MODULE__)

      Module.register_attribute(__MODULE__, :gets, accumulate: true)
      @before_compile unquote(__MODULE__)

      def server_name() do
        unquote(app_name)
      end

    end
  end

  defmacro __before_compile__(_) do
    quote do
      def get_apis() do
        @gets
      end
    end
  end

  defmacro get(api, do: block) do
    quote do
      IO.inspect("#{unquote(api)}", label: "api is")
      @gets unquote(api)
    end
  end
end

defmodule Meta.Obscure do
  @moduledoc """
  This module will include all macro that obscure `KeyWord` like `def` in elixir
  """
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      alias unquote(__MODULE__)

      use Meta.ErrorDealer
      # obscure
      # 1. def
      import Kernel, except: [def: 2]
      Module.register_attribute(__MODULE__, :rejects, accumulate: true)
      @on_definition {Annotation, :on_definition}
      @before_compile unquote(__MODULE__)

    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def rejects() do
        @rejects
      end
      def forbidden?(fun_name) do
        Keyword.get(@rejects, fun_name, false)
      end
    end
  end

  defmacro def({func_name, _, args} = func_define, [ctx: ctx], [do: block]) do
    quote do
      require Logger

      #      [_params, ctx] = unquote(args)
      #      ctx = __MODULE__.modify_ctx(unquote(func_name), ctx)
      Kernel.def(
        unquote(func_define),
        do:
          (
            IO.inspect(unquote(ctx))
            unquote(block)
            )
      )
    end
  end

  defmacro def({func_name, _, args} = func_define, [throws: strategy], [do: block]) do
    quote do
      require Logger

      #      [_params, ctx] = unquote(args)
      #      ctx = __MODULE__.modify_ctx(unquote(func_name), ctx)
      Kernel.def(
        unquote(func_define),
        do:
          (
            case unquote(strategy) do
              {:hold, return: fall_back} ->
                no_panic unquote(func_name), fall_back: fall_back do
                  unquote(block)
                end

              _ -> unquote(block)
            end
            )
      )
    end
  end

  defmacro def({func_name, _, _args} = func, do: block) do
    quote do
      Kernel.def(
        unquote(func),
        do:
          (
            if not forbidden?(unquote(func_name)) do
              unquote(block)
            else
              :reject
            end
        )
      )
    end
  end
end

defmodule Annotation do
  @reserved_noun [:aspects, :inject_func, :time_consume_cal?]
  def on_definition(env, _access, name, _args, _guards, _body) do
    case Enum.member?(@reserved_noun, name) do
      true ->
        :skip

      false ->
        case Module.get_attribute(env.module, :reject) do
          nil ->
            :skip

          v ->
            Module.put_attribute(env.module, :rejects, {name, v})
            Module.delete_attribute(env.module, :reject)
        end
    end
  end
end

defmodule Api do
  use MyHttpServer, otp_app: :lol
  use Meta.Obscure

  # ----
  #  params do
  #    requires("uid", type: :integer)
  #    requires("name", type: :string)
  #  end


  get "hero" do
    IO.inspect("noxus")
  end

  get "items" do
    IO.inspect("sword")
  end

  @reject true
  def visit() do
    :hello
  end
end
```

- Macro.prewalk() & Macro.postwalk()
- Var! 

```
使用var！可以破除elixir的hygiene的特性, 一般我们在任何时候都不应该用到。但是可以窥看一下是什么效果

```



