defmodule Blur.IRCHandler.Names do
  @moduledoc """
  Stores the names of the users in a channel
  """

  require Logger

  alias Blur.Channel

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, client}
  end

  def handle_info({:names_list, channel, names}, state) do
    names = String.split(names, " ")
    names |> Enum.each(fn (name) ->
      Channel.add_user(channel, name)
    end)

    {:noreply, state}
  end

  def handle_info({:joined, channel, name}, state) do
    Logger.debug "Joined #{channel} #{name}"

    Channel.add_user(channel, name)

    {:noreply, state}
  end

  def handle_info({:parted, channel, name}, state) do
    Logger.debug "Parted #{channel} #{name}"

    Channel.remove_user(channel, name)

    {:noreply, state}
  end

  def handle_info({:mode, channel, op, name}, state) do
    Logger.debug "#{channel} #{op} #{name}"
    {:noreply, state}
  end

  # Catch-all for messages you don't care about
  def handle_info(msg, state) do
    {:noreply, state}
  end
end
