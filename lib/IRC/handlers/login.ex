defmodule Blur.IRCHandler.Login do
  require Logger

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, %{client: client}}
  end

  def terminate(reason, _state) do
    Logger.error reason
    :ok
  end

  def handle_info(:logged_in, state) do
    Logger.debug "Logged in!"

    state.client |> Blur.IRC.request_twitch_capabilities

    {:noreply, state}
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end