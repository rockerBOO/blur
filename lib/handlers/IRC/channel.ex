defmodule Blur.IRC.Channel do
  @moduledoc """
  Handles IRC Channels events
  """
  use GenServer
  require Logger
  alias ExIRC.Client

  @spec start_link([client :: pid]) :: GenServer.on_start()
  def start_link([client]) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl GenServer
  @spec init(client :: pid) :: {:ok, pid}
  def init(client) do
    Client.add_handler(client, self())
    {:ok, client}
  end

  @doc """
  Handle channel messages
  """
  @impl GenServer
  @spec handle_info(
          {:joined, channel :: charlist}
          | {:joined, channel :: charlist, sender :: %ExIRC.SenderInfo{}}
          | {:logon, charlist, nick :: charlist, charlist, charlist}
          | {:kicked, sender :: %ExIRC.SenderInfo{}, channel :: charlist},
          client :: pid
        ) :: {:noreply, pid}
  def handle_info({:joined, channel}, client) do
    Logger.debug("Joined #{channel}")

    {:noreply, client}
  end

  def handle_info({:joined, _channel, _sender}, client) do
    {:noreply, client}
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, _state) do
    :ok
  end
end
