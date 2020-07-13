defmodule Blur.IRC.Connection do
  @moduledoc """
  Handles IRC Connection events
  """

  require Logger
  use GenServer
  alias Blur.IRC.Connection.State

  defmodule State do
    @moduledoc """
    IRC connection state
    """
    defstruct host: "irc.twitch.tv",
              port: 6667,
              nick: "",
              user: "",
              name: "",
              debug?: true,
              client: nil
  end

  @spec start_link(list) :: GenServer.on_start()
  def start_link([client, user]) do
    GenServer.start_link(__MODULE__, %State{client: client, user: user, nick: user, name: user})
  end

  @impl true
  @spec init(%State{}) :: {:ok, %State{}}
  def init(state) do
    ExIRC.Client.add_handler(state.client, self())
    Blur.IRC.connect!(state.client, state.host, state.port)

    {:ok, state}
  end

  def login(client, nick, token) do
    # Login to IRC
    case Blur.IRC.login(client, nick, token) do
      {:error, :not_logged_in} ->
        Logger.info("Logging in with #{nick} failed.")

      :ok ->
        :ok
    end
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

    :ok = login(state.client, state.user, Blur.token())
    {:noreply, state}
  end

  # Handle disconnection
  def handle_info({:disconnected}, state) do
    Logger.debug(":disconnected")

    {:noreply, state}
  end

  # Handle tagged message disconnect
  def handle_info({:disconnected, "@" <> _cmd, _msg}, state) do
    Logger.debug(":disconnected")
    {:noreply, state}
  end

  # Catch-all
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
