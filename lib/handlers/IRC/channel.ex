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

  @impl true
  @spec init(client :: pid) :: {:ok, pid}
  def init(client) do
    Client.add_handler(client, self())
    Logger.debug("Receiving channel changes")
    {:ok, client}
  end

  @doc """
  Handle channel messages
  """
  @impl true
  @spec handle_info({:joined, channel :: charlist}, client :: pid) :: {:noreply, pid}
  def handle_info({:joined, channel}, client) do
    Logger.debug("Joined #{channel}")

    {:ok, _} = Blur.Channel.start_link(client, channel)

    {:noreply, client}
  end

  @impl true
  @spec handle_info({:joined, channel :: charlist, sender :: %ExIRC.SenderInfo{}}, pid) ::
          {:noreply, pid}
  def handle_info({:joined, _channel, _sender}, client) do
    {:noreply, client}
  end

  @spec handle_info({:logon, charlist, nick :: charlist, charlist, charlist}, state :: pid) ::
          {:noreply, pid}
  def handle_info({:logon, _, _nick, _, _}, state) do
    Logger.debug("Drop logon message")
    {:noreply, state}
  end

  @spec handle_info({:kicked, sender :: %ExIRC.SenderInfo{}, channel :: charlist}, state :: pid) ::
          {:noreply, pid}
  def handle_info({:kicked, sender, channel}, state) do
    by = sender.nick
    Logger.debug("We were kicked from #{channel} by #{by}")
    {:noreply, state}
  end

  # Drops unknown messages
  def handle_info(msg, state) do
    IO.puts("channel unknown")
    IO.inspect(msg)

    {:noreply, state}
  end

  @impl true
  def terminate(reason, _state) do
    IO.inspect(reason)
    :ok
  end
end
