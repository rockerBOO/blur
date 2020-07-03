defmodule Blur.IRC.Channel do
  @moduledoc """
  Handles IRC Channels events
  """
  use GenServer
  require Logger
  alias ExIRC.Client

  @spec start_link(client :: pid) :: GenServer.on_start()
  def start_link(client) do
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

  def handle_info({:logon, _, _nick, _, _}, state) do
    {:noreply, state}
  end

  def handle_info({:kicked, sender, channel}, state) do
    by = sender.nick
    Logger.debug("We were kicked from #{channel} by #{by}")
    {:noreply, state}
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    IO.inspect(reason)
    :ok
  end
end
