defmodule Blur.IRC.Connection do
  @moduledoc """
  Handles IRC Connection events
  """

  require Logger
  use GenServer
  alias Blur.IRC.Connection.State

  @spec start_link(client :: pid) :: GenServer.on_start()
  def start_link(client) do
    GenServer.start_link(__MODULE__, %State{client: client})
  end

  @impl true
  @spec init(%State{}) :: {:ok, %State{}}
  def init(state) do
    ExIRC.Client.add_handler(state.client, self())
    Blur.IRC.connect!(state.client, state.host, state.port)

    {:ok, state}
  end

  @impl true
  @spec handle_info(
          {:connected, server :: binary, port :: non_neg_integer()}
          | {:disconnected}
          | {:disconnected, cmd :: binary, msg :: binary},
          %State{}
        ) :: {:noreply, %State{}}
  def handle_info({:connected, server, port}, state) do
    Logger.debug("Connected to #{server}:#{port}")

    nick = Blur.Env.fetch!(:username)

    # Login to IRC
    :ok = Blur.IRC.login(state.client, nick, Blur.token())

    {:noreply, state}
  end

  def handle_info({:disconnected}, state) do
    Logger.debug(":disconnected")

    {:noreply, state}
  end

  def handle_info({:disconnected, "@" <> _cmd, _msg}, state) do
    Logger.debug(":disconnected")
    {:noreply, state}
  end

  # Catch-all
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
