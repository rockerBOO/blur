defmodule Blur.IRCHandler.Connection do
  @moduledoc """
  Handles IRC Connection events

    :connected server, port
    :disconnected
  """

  require Logger

  def start_link(client, state \\ []) do
    GenServer.start_link(__MODULE__, (state |> Keyword.put(:client, client)))
  end

  def init(state) do
    client = Keyword.get(state, :client)

    client |> ExIrc.Client.add_handler self
    client |> Blur.IRC.connect(
      Keyword.get(state, :host), Keyword.get(state, :port)
    )

    {:ok, state}
  end

  def handle_info({:connected, server, port}, state) do
    Logger.debug "Connected to #{server}:#{port}"

    nick = Blur.Env.fetch!(:username)

    # Login to IRC
    client = Keyword.get(state, :client)
    client |> Blur.IRC.login(nick, Blur.token)

    {:noreply, state}
  end

  def handle_info(:disconnected, state) do
    Logger.debug ":disconnected"

    {:noreply, state}
  end

  # Catch-all
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
