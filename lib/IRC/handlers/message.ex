defmodule Blur.IRCHandler.Message do
  require Logger

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    client |> ExIrc.Client.add_handler self

    {:ok, %{client: client}}
  end

  # Handles messages sent from IRC
  def handle_info({:received, msg, user, channel}, state) do
    Logger.debug "#{channel} #{user}: #{msg}"

    {:noreply, state}
  end

  # Drop uncaught messages
  def handle_info(info, state) do
    {:noreply, state}
  end

  def terminate(reason, state) do
    IO.inspect reason

    :ok
  end
end