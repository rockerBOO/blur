defmodule Blur.Bot do
  @moduledoc """
  Use this to get the necessary bot features.

  start_link(["#rockerboo", []])
  stop(bot)

  handle_in
  handle_connect
  handler_disconnnect
  """

  defstruct name: "",
            adapter: nil

  require Logger

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use GenServer
      require Logger

      @adapter Blur.Adapters.IRC

      @def """
      Start a Bot. This starts it under a DynamicSupervisor.
      """
      def start_link(opts) do
        Blur.Supervisor.start_bot(__MODULE__, opts)
      end

      @def """
      Stop the bot. This also removes the bot from the Blur.Supervisor.Bot.
      """
      def stop(bot) do
        Blur.Supervisor.stop_bot(bot)
      end

      def __adapter__, do: @adapter

      @def """
      Initializes the Bot State. Start up the Adapter Process.
      """
      def init({bot, opts}) do
        name = Keyword.get(opts, :name)

        {:ok, adapter} = Blur.Adapters.IRC.start_link(bot, opts)

        {:ok,
         %Blur.Bot{
           adapter: adapter,
           name: name
         }}
      end

      @def """
      Handle connections to the Adapter service.
      """
      def handle_connect(state) do
        {:ok, state}
      end

      @def """
      Handle disconnections to the Adapter service.
      """
      def handle_disconnect(_reason, state) do
        # Auto respond with a reconnect.
        {:reconnect, state}
      end

      @def """
      Handle messages/notices coming into the bot.
      """
      def handle_in(%Blur.Message{} = msg, state) do
        {:dispatch, msg, state}
      end

      def handle_in(%Blur.Notice{} = notice, state) do
        {:dispatch, notice, state}
      end

      def handle_in(msg, state) do
        {:noreply, state}
      end

      @def false
      def handle_call(:handle_connect, _from, state) do
        case handle_connect(state) do
          {:ok, state} ->
            {:reply, :ok, state}
        end
      end

      def handle_cast({:handle_in, msg}, state) do
        case __MODULE__.handle_in(msg, state) do
          {:dispatch, msg, state} ->
            {:noreply, state}

          _ ->
            {:noreply, state}
        end
      end

      @def false
      def handle_cast({:send, msg}, %{adapter: adapter} = state) do
        @adapter.send(adapter, msg)

        {:noreply, state}
      end

      def handle_cast(_, state) do
        {:noreply, state}
      end

      @def false
      def handle_info(msg, state) do
        {:noreply, state}
      end

      @def false
      def terminate(_reason, _state) do
        :ok
      end

      @def false
      def code_change(_old, state, _extra) do
        {:ok, state}
      end

      defoverridable [
        {:handle_connect, 1},
        {:handle_disconnect, 2},
        {:handle_in, 2},
        {:terminate, 2},
        {:code_change, 3},
        {:handle_info, 2}
      ]
    end
  end

  def child_spec([arg1, arg2]) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [arg1, arg2]}
    }
  end

  @doc """
  Start the Blur Bot.

  ## Example
      iex> Blur.Bot.start_link(Blur.BotExample, name: "800807", rooms: ["#rockerboo"])

  """
  @spec start_link(bot :: atom, opts :: list) :: GenServer.on_start()
  def start_link(bot, opts) do
    # Starts the bot. Bots are started using their module name (which is an atom)
    GenServer.start_link(bot, {bot, opts})
  end

  @doc """
  Send a message via the bot.
  """
  def send(pid, msg) do
    GenServer.cast(pid, {:send, msg})
  end

  @doc """
  Name of bot
  """
  def name(pid) do
    GenServer.call(pid, :name)
  end

  @doc """
  Handle incoming bot messages.
  """
  # @spec handle_in(bot :: GenServer
  def handle_in(bot, msg) do
    GenServer.cast(bot, {:handle_in, msg})
  end

  @doc """
  Handle connection events.
  """
  def handle_connect(bot) do
    GenServer.call(bot, :handle_connect)
  end

  @doc """
  Handle disconnection events.
  """
  def handle_disconnect(bot, reason) do
    GenServer.call(bot, {:handle_disconnect, reason})
  end
end
