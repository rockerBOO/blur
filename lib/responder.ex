defmodule Blur.Responder do
  defmacro __using__(_opts) do
    quote location: :keep do
      import unquote(__MODULE__)
      import Kernel, except: [send: 2]

      Module.register_attribute(__MODULE__, :hear, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  def start_link(module, {name, opts, bot}) do
    GenServer.start_link(module, {name, opts, bot})
  end

  def start([bot, opts]) do
    DynamicSupervisor.start_child(Blur.Supervisor.Responder, {Blur.Responder, [bot, opts]})
  end

  def send(%Blur.Message{bot: bot} = msg, text) do
    Blur.Bot.send(bot, %{msg | text: text})
  end

  @doc """
  Matches messages based on the regular expression.
  ## Example
      hear ~r/hello/, msg do
        # code to handle the message
      end
  """
  defmacro hear(regex, msg, state \\ Macro.escape(%{}), do: block) do
    name = unique_name(:hear)

    quote do
      @hear {unquote(regex), unquote(name)}
      @doc false
      def unquote(name)(unquote(msg), unquote(state)) do
        unquote(block)
      end
    end
  end

  defp unique_name(type) do
    String.to_atom("#{type}_#{System.unique_integer([:positive, :monotonic])}")
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def init({name, opts, bot}) do
        {:ok,
         %{
           name: name,
           opts: opts,
           responders: [],
           bot: bot
         }}
      end
    end
  end
end
