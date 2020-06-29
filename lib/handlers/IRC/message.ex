defmodule Blur.IRC.Message do
  @moduledoc """
  Handles incoming messages on the IRC connection.
  """

  require Logger
  use GenServer

  alias Blur.Command
  alias Blur.Parser.Message
  alias Blur.Channel
  alias ExIRC.Client

  @doc """
  Start message handler.
  """
  @spec start_link(client :: pid) :: GenServer.on_start()
  def start_link(client) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl true
  @spec init(client :: pid) :: {:ok, pid}
  def init(client) do
    Client.add_handler(client, self())
    Logger.debug("Receiving messages")
    {:ok, client}
  end

  @spec parse_message(channel :: binary, user :: charlist, msg :: charlist) :: nil | :ok
  def parse_message(channel, user, msg) do
    # Logger.debug "#{channel} #{user}: #{msg}"

    if Channel.config?(channel) do
      Message.parse(msg, user, channel)
      |> Command.run(user, channel)
      |> case do
        :ok -> Logger.debug("Command send properly")
      end
    end
  end

  @doc """
  Parse out message from tagged message.
  """
  @spec parse(%ExIRC.Message{}) :: %ExIRC.Message{}
  def parse(irc_message) do
    [_server, cmd, channel | msg] = Enum.at(irc_message.args, 0) |> String.split(" ")

    message = Enum.join(msg, " ")

    %ExIRC.Message{
      irc_message
      | args: [channel, String.slice(message, 1, String.length(message))],
        cmd: cmd
    }
  end

  @doc """
  Handle messages from IRC connection.
  """
  @impl true
  @spec handle_info({:received, message :: charlist, %ExIRC.SenderInfo{}}, state :: pid) ::
          {:noreply, pid}
  def handle_info({:received, message, sender}, state) do
    from = sender.nick
    Logger.debug("#{from} sent us a private message: #{message}")
    {:noreply, state}
  end

  @spec handle_info(
          {:received, message :: charlist, %ExIRC.SenderInfo{}, channel :: charlist},
          pid
        ) :: {:noreply, pid}
  def handle_info({:received, message, sender, channel}, state) do
    from = sender.nick
    Logger.debug("#{channel} #{from}: #{message}")
    {:noreply, state}
  end

  @spec handle_info(
          {:mentioned, message :: charlist, sender :: %ExIRC.SenderInfo{}, channel :: charlist},
          pid
        ) :: {:noreply, pid}
  def handle_info({:mentioned, message, sender, channel}, state) do
    from = sender.nick
    Logger.debug("#{from} mentioned us in #{channel}: #{message}")
    {:noreply, state}
  end

  # Uncaught end names list
  #  {:unrecognized, "366", %ExIRC.Message{args: ["800807", "#rockerboo", "End of /NAMES list"], cmd: "366", ctcp: false, host: [], nick: [], server: "800807.tmi.twitch.tv", user: []}}
  @spec handle_info({:unrecognized, code :: charlist, %ExIRC.Message{}}, pid) :: {:noreply, pid}
  def handle_info({:unrecognized, "366", _}, state) do
    {:noreply, state}
  end

  # CAP reply
  @spec handle_info({:unrecognized, code :: charlist, %ExIRC.Message{}}, pid) :: {:noreply, pid}
  def handle_info({:unrecognized, "CAP", _}, state) do
    {:noreply, state}
  end

  # Tagged message
  @spec handle_info({:unrecognized, code :: charlist, msg :: %ExIRC.Message{}}, pid) ::
          {:noreply, pid}
  def handle_info({:unrecognized, "@" <> cmd, msg}, state) do
    opts =
      Blur.Parser.Twitch.parse(cmd)
      |> Enum.reduce(%{}, fn [k, v], acc -> Map.put(acc, k, v) end)

    %{args: [channel, message]} = parse(msg)

    Logger.debug("#{channel} #{opts["display-name"]}: #{message}")

    {:noreply, state}
  end

  # Drop uncaught messages
  def handle_info(_info, state) do
    {:noreply, state}
  end
end
