defmodule Blur.IRC.Message do
  @moduledoc """
  Handles incoming messages on the IRC connection.
  """

  require Logger
  use GenServer

  alias ExIRC.Client

  @doc """
  Start message handler.
  """
  @spec start_link([client :: GenServer.server()]) :: GenServer.on_start()
  def start_link([client]) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl GenServer
  @spec init(client :: GenServer.server()) :: {:ok, pid | atom}
  def init(client) do
    Client.add_handler(client, self())
    {:ok, client}
  end

  @spec parse_message(channel :: binary, user :: binary, msg :: binary, tags :: map) :: :ok
  def parse_message(channel, _, msg, tags \\ %{}) do
    Logger.debug("#{channel} #{tags["display-name"]}: #{msg}")
    :ok
  end

  @doc """
  Handle messages from IRC connection.
  """
  @impl GenServer
  @spec handle_info(
          {:received, message :: charlist, sender :: %ExIRC.SenderInfo{}}
          | {:received, message :: charlist, sender :: %ExIRC.SenderInfo{}, channel :: charlist}
          | {:mentioned, message :: charlist, sender :: %ExIRC.SenderInfo{}, channel :: charlist}
          | {:unrecognized, code :: charlist, message :: %ExIRC.Message{}},
          state :: pid
        ) ::
          {:noreply, pid}

  # Private messages. (Unsure if used by Twitch)
  def handle_info({:received, message, sender}, state) do
    from = sender.nick
    Logger.debug("#{from} sent us a private message: #{message}")
    {:noreply, state}
  end

  # Handle received messages. Tagged messages don't land here current.
  def handle_info({:received, message, sender, channel}, state) do
    from = sender.nick
    Logger.debug("#{channel} #{from}: #{message}")
    {:noreply, state}
  end

  # Uncaught end names list
  #  {:unrecognized, "366", %ExIRC.Message{args: ["800807", "#rockerboo", "End of /NAMES list"], cmd: "366", ctcp: false, host: [], nick: [], server: "800807.tmi.twitch.tv", user: []}}
  def handle_info({:unrecognized, "366", _}, state) do
    {:noreply, state}
  end

  # CAP reply
  def handle_info({:unrecognized, "CAP", _}, state) do
    {:noreply, state}
  end

  # Tagged message
  def handle_info({:unrecognized, "@" <> code, msg}, state) do
    case Blur.IRC.TwitchTag.parse_tagged_message(msg) do
      %{args: [channel, message], cmd: "PRIVMSG", user: user} ->
        parse_message(channel, user, message, Blur.Parser.Twitch.parse_tags(code))

      _ ->
        nil
    end

    {:noreply, state}
  end

  # Drop uncaught messages
  def handle_info(_info, state) do
    {:noreply, state}
  end

  @impl GenServer
  def terminate(reason, _state) do
    IO.inspect("terminate #{__MODULE__}")
    IO.inspect(reason)
    :ok
  end
end
