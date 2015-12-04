defmodule Blur.IRCHandler.Channel do
  @moduledoc """
  Handles IRC Channels events

    :joined
  """

  require Logger

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, client}
  end

  def handle_info({:joined, channel}, state) do
    Logger.debug "Joined #{channel}"

    {:ok, _} = Blur.Channel.start_link(channel)

    {:noreply, state}
  end

  # Catch-all for messages you don't care about
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
