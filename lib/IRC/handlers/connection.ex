defmodule Blur.IRCHandler.Connection do
  require Logger

  def start_link(client, state \\ %Blur.Connection.State{}) do
    GenServer.start_link(__MODULE__, [%{state | client: client}])
  end

  def init([state]) do
    state.client |> ExIrc.Client.add_handler self
    state.client |> Blur.IRC.connect(state.host, state.port)

    {:ok, state}
  end

  def handle_info({:connected, server, port}, state) do
    Logger.debug "Connected to #{server}:#{port}"

    nick = Blur.Env.fetch!(:username)

    # Login to IRC
    state.client |> Blur.IRC.login(nick, Blur.token)

    {:noreply, state}
  end

  def handle_info(:disconnected, state) do
    Logger.debug ":disconnected"

    {:noreply, state}
  end

  # Catch-all
  def handle_info(msg, state) do
    {:noreply, state}
  end
end