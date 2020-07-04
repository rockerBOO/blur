defmodule Blur.Channels do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @impl GenServer
  def init(:ok) do
    {:ok, []}
  end

  @doc """
  Add channel
  """
  @spec add(pid, channel :: binary) :: :ok
  def add(pid, channel) do
    GenServer.cast(pid, {:add, channel})
  end

  @doc """
  Delete channel
  """
  @spec delete(pid, channel :: binary) :: :ok
  def delete(pid, channel) do
    GenServer.cast(pid, {:delete, channel})
  end

  @doc """
  Find channel
  """
  @spec find(pid, channel :: binary) :: [{binary, GenServer.server()}]
  def find(pid, channel) do
    GenServer.call(pid, {:find, channel})
  end

  @doc """
  Get the list of channels, with their process
  """
  @spec channels(pid :: GenServer.server()) :: [{binary, GenServer.server()}]
  def channels(pid), do: GenServer.call(pid, {:channels})

  @impl GenServer
  @spec handle_cast(
          {:add, channel :: binary}
          | {:delete, channel :: binary},
          [{binary, GenServer.server()}]
        ) ::
          {:noreply, [{binary, GenServer.server()}]}
  def handle_cast({:add, channel}, state) do
    {:ok, pid} = Blur.Channel.start_link(channel)
    {:noreply, state ++ [{channel, pid}]}
  end

  def handle_cast({:delete, channel}, state) do
    {:noreply, Enum.filter(state, fn {chan, _} -> chan !== channel end)}
  end

  @impl GenServer
  @spec handle_call({:find, channel :: charlist} | {:channels}, from :: tuple, state :: list) ::
          {:reply, [{binary, GenServer.server()}] | {binary, GenServer.server()},
           :error | {:ok, pid}}
  def handle_call({:find, channel}, _from, state) do
    {:reply, Enum.find(state, fn {chan, _} -> chan === channel end), state}
  end

  def handle_call({:channels}, _from, state), do: {:reply, state, state}
end
