defmodule Blur.Channels do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, %{client: nil}}
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
  @spec find(pid, channel :: binary) :: map
  def find(pid, channel) do
    GenServer.call(pid, {:find, channel})
  end

  @spec handle_cast({:add, channel :: binary} | {:delete, channel :: binary}, map) ::
          {:noreply, map}
  def handle_cast({:add, channel}, channels) do
    {:ok, pid} = Blur.Channel.start_link(channel)
    {:noreply, Map.put(channels, channel, pid)}
  end

  def handle_cast({:delete, channel}, channels) do
    {:noreply, Map.delete(channels, channel)}
  end

  @spec handle_call({:find, charlist}, map) :: {:noreply, :error | {:ok, pid}}
  def handle_call({:find, channel}, channels) do
    {:noreply, Map.fetch(channels, channel)}
  end
end
