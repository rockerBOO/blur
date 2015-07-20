defmodule Blur.IRC do
  require Logger

  @doc """
  Request the CAP (capability) on the server

  ## Example
  cap_request(ExIrc.Client, ':twitch.tv/membership')
  """
  def cap_request(client, cap) do
    client |> ExIrc.Client.cmd(['CAP ', 'REQ ', cap])
  end

  @doc """
  Request twitch for capabilities
  """
  def request_twitch_capabilities(client) do
    # Request capabilities before joining the channel
    client |> cap_request(":twitch.tv/membership")
    client |> cap_request(":twitch.tv/commands")
  end

  # Chat Key
  def parse_token(<<"oauth:"::utf8, _>> = pass),
  do: pass

  # Access token
  def parse_token(access_token),
  do: "oauth:" <> access_token

  def connect(client, host, port),
  do: client |> ExIrc.Client.connect!(host, port)

  def connect(client) do
    %{host: host, port: port} = %Blur.Connection.State{}

    client |> ExIrc.Client.connect!(host, port)
  end

  def login(client, nick, pass) do
    client |> ExIrc.Client.logon(pass, nick, nick, nick)
  end

  def join_many(client, channels) do
    channels |> Enum.each(&join(client, &1))
  end

  def join(client, "#" <> _ = channel) do
    Logger.debug "Join #{channel}"
    client |> ExIrc.Client.join(channel)
  end

  def join("#" <> _ = channel),
    do: :irc_client |> join(channel)

  def say(client, "#" <> _ = channel, msg) do
    client |> ExIrc.Client.msg(:privmsg, channel, msg)
  end

  def say("#" <> _ = channel, msg),
    do: :irc_client |> say(channel, msg)


end