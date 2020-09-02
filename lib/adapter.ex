defmodule Blur.Adapter do
  @moduledoc """
  Blur Adapter Behaviour
  An adapter is the interface to the service your bot runs on. To implement an
  adapter you will need to translate messages from the service to the
  `Blur.Message` struct and call `Blur.Robot.handle_in(robot, msg)`.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [send: 2]

      @behaviour Blur.Adapter
      use GenServer

      def send(pid, %Blur.Message{} = msg) do
        GenServer.cast(pid, {:send, msg})
      end

      @doc false
      def start_link(robot, opts) do
        Blur.Adapter.start_link(__MODULE__, opts)
      end

      @doc false
      def stop(pid, timeout \\ 5000) do
        ref = Process.monitor(pid)
        Process.exit(pid, :normal)

        receive do
          {:DOWN, ^ref, _, _, _} -> :ok
        after
          timeout -> exit(:timeout)
        end

        :ok
      end

      @doc false
      defmacro __before_compile__(_env) do
        :ok
      end

      defoverridable __before_compile__: 1, send: 2
    end
  end

  @doc false
  def start_link(module, opts) do
    GenServer.start_link(module, {self(), opts})
  end

  # @type robot :: pid
  # @type state :: term
  # @type opts :: any
  # @type msg :: Blur.Message.t()

  @callback send(pid, binary) :: term
end
