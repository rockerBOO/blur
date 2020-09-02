defmodule Blur.Adapters.IRC do
  use Blur.Adapter

  require Logger
  alias ExIRC.Client

  @impl GenServer
  def init({bot, opts}) do
    Logger.debug("#{inspect(opts)}")

    {:ok, client} = ExIRC.start_client!()
    Client.add_handler(client, self())

    Kernel.send(self(), :connect)
    {:ok, {bot, opts, client}}
  end

  @doc """
  Request the CAP (capability) on the server

  ## Example
      Blur.IRC.cap_request client, [':twitch.tv/membership']
      :ok
  """
  @spec cap_request(client :: GenServer.server(), list) :: :ok | {:error, atom}
  def cap_request(_, []), do: :ok

  def cap_request(client, [head | tail]) do
    case Client.cmd(client, "CAP REQ #{head}") do
      :ok -> cap_request(client, tail)
      {:error, _} = error -> error
    end
  end

  @doc """
  Request twitch for capabilities

  ## Example
      Blur.IRC.request_twitch_capabilities :twitchirc
      :ok
  """
  @spec request_twitch_capabilities(client :: pid | atom) :: :ok | {:error, atom}
  def request_twitch_capabilities(client) do
    # Request capabilities before joining the channel

    requests = [":twitch.tv/membership", ":twitch.tv/commands", ":twitch.tv/tags"]

    cap_request(client, requests)
  end

  @impl Blur.Adapter
  @spec send(pid, msg :: binary) :: :ok | {:error, atom}
  def send(pid, msg) do
    GenServer.cast(pid, {:send, msg})
  end

  # Send message to Twitch
  @impl GenServer
  def handle_cast(
        {:send, %Blur.Message{text: text, channel: channel}},
        {_bot, _opts, client} = state
      ) do
    ExIRC.Client.msg(client, :privmsg, channel, text)

    {:noreply, state}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end

  # Connect to Twitch
  @impl GenServer
  def handle_info(:connect, state = {_bot, opts, client}) do
    host = Keyword.get(opts, :server, "irc.chat.twitch.tv")
    port = Keyword.get(opts, :port, 6667)
    ssl? = Keyword.get(opts, :ssl?, false)

    case ssl? do
      true -> Client.connect_ssl!(client, host, port)
      false -> Client.connect!(client, host, port)
    end

    {:noreply, state}
  end

  # On connecting to Twitch
  def handle_info({:connected, server, port}, state = {bot, opts, client}) do
    Logger.info("Connected to #{server}:#{port}")

    # pass = Keyword.fetch!(opts, :password)
    pass = System.fetch_env!("TWITCH_CLIENT_KEY")

    nick = Keyword.fetch!(opts, :name)

    Client.logon(client, pass, nick, nick, nick)

    :ok = Blur.Bot.handle_connect(bot)
    {:noreply, state}
  end

  # On logon to Twitch
  def handle_info(:logged_in, state = {_bot, opts, client}) do
    Logger.info("Logged in")

    request_twitch_capabilities(client)

    channels = Keyword.fetch!(opts, :channels)

    for channel <- channels do
      Client.join(client, channel)
    end

    {:noreply, state}
  end

  def handle_info(
        {:unrecognized, "@" <> _ = cmd, %ExIRC.Message{} = msg},
        {bot, _opts, _client} = state
      ) do
    case Blur.Twitch.Tag.parse(cmd, msg) do
      {:privmsg, channel, user, text, tags} ->
        Blur.Bot.handle_in(bot, %Blur.Message{
          channel: channel,
          user: user,
          text: text,
          tags: tags
        })

      {:usernotice, channel, text, tags} ->
        Blur.Bot.handle_in(bot, Blur.Notice.from_tags(channel, text, tags))

      {:userstate, channel, text, tags} ->
        Blur.Bot.handle_in(bot, Blur.Notice.from_tags(channel, text, tags))

      {:clearchat, channel, %{}, tags} ->
        Logger.debug("#{channel}: clearchat #{tags["ban-duration"]}s #{tags["target-user-id"]}")

      {:clearmsg, channel, msg, tags} ->
        Logger.debug("#{channel} clearmsg #{tags["login"]}: #{msg}")

      {:roomstate, channel, tags} ->
        Logger.debug(
          "#{channel} emotes:#{tags["emote-only"]} followers:#{tags["followers-only"]} r9k:#{
            tags["r9k"]
          } subs:#{tags["subs-only"]} slow:#{tags["slow"]}"
        )

      msg ->
        IO.inspect(msg)
    end

    {:noreply, state}
  end

  def handle_info({:parted, _channel, %ExIRC.SenderInfo{} = _sender}, state) do
    {:noreply, state}
  end

  def handle_info({:joined, _channel, %ExIRC.SenderInfo{} = _sender}, state) do
    {:noreply, state}
  end

  # {:names_list, channel :: binary, nameslist :: binary}
  def handle_info({:names_list, _channel, _nameslist}, state) do
    {:noreply, state}
  end

  # {:receieved, channel :: binary, user :: Blur.Twitch.User, msg :: Blur.Message}
  def handle_info({:received, channel, user, msg}, state) do
    Logger.debug("#{channel} #{user.display_name}: #{msg.text}")
    {:noreply, state}
  end

  # {:notice, channel :: binary, user :: Blur.Twitch.User, msg :: Blur.Message}
  def handle_info({:notice, channel, user, msg}, state) do
    Logger.debug("#{channel} #{user.display_name}: #{msg.text}")
    {:noreply, state}
  end

  def handle_info(:disconnected, state = {bot, _opts, _client}) do
    Blur.Bot.handle_disconnect(bot, nil)
    {:noreply, state}
  end

  # End of /NAMES list
  def handle_info({:unrecognized, "366", %ExIRC.Message{}}, state) do
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.debug("Unknown message: #{inspect(msg)}")
    {:noreply, state}
  end
end
