defmodule Blur.IRC do
  @moduledoc """
  Shortcuts for IRC options to auto join channels

  client is a process of `ExIRC.Client.start_link`
  """

  require Logger

  @doc """
  Request the CAP (capability) on the server

  ## Example
      Blur.IRC.cap_request client, ':twitch.tv/membership'
      :ok
  """
  @spec cap_request(client :: pid | atom, cap :: binary) :: :ok | {:error, atom}
  def cap_request(client, cap) do
    ExIRC.Client.cmd(client, "CAP REQ #{cap}")
  end

  @doc """
  Request twitch for capabilities

  ## Example
      Blur.IRC.request_twitch_capabilities client
      :ok
  """
  @spec request_twitch_capabilities(client :: pid | atom) :: :ok | {:error, atom}
  def request_twitch_capabilities(client) do
    # Request capabilities before joining the channel
    cap_request(client, ":twitch.tv/membership")
    cap_request(client, ":twitch.tv/commands")
    cap_request(client, ":twitch.tv/tags")
  end

  @doc """
  Parse oauth token

  ## Example
      iex> Blur.IRC.parse_token "oauthhashherewithlettersandnumbers"
      "oauth:oauthhashherewithlettersandnumbers"
  """
  def parse_token(<<"oauth:"::utf8, _>> = pass),
    do: pass

  def parse_token(access_token),
    do: "oauth:" <> access_token

  @doc """
  Connect to the IRC server.

  ## Example
      Blur.IRC.connect client, "irc.twitch.tv", 6667
      :ok
  """
  @spec connect!(client :: pid | atom, host :: binary, port :: non_neg_integer) :: :ok
  def connect!(client, host, port),
    do: ExIRC.Client.connect!(client, host, port)

  @doc """
  Login to the server.

  ## Example 
      Blur.IRC.login client, "rockerBOO", "oauth:oauthhashherewithlettersandnumbers"
      :ok
  """
  @spec login(client :: pid | atom, nick :: binary, pass :: binary) ::
          :ok | {:error, :not_connected}
  def login(client, nick, pass),
    do: ExIRC.Client.logon(client, pass, nick, nick, nick)

  @doc """
  Join many channels.
  ## Example 
      Blur.IRC.join_many client, ["#rockerboo", "#adattape"]
      :ok
  """
  @spec join_many(client :: pid | atom | atom, list) :: :ok | {:error, atom}
  def join_many(client, channels) do
    channels |> Enum.each(&join(client, &1))
  end

  @doc """
  Join an IRC channel.

  ## Example
      Blur.IRC.join client, "#rockerboo"
      :ok
  """
  @spec join(client :: pid | atom, channel :: binary) :: :ok | {:error, atom}
  def join(client, channel) do
    Logger.debug("Join #{channel}")
    ExIRC.Client.join(client, channel)
  end

  def join(client, channel),
    do: join(client, channel)

  @doc """
  Part from IRC channel.

  ## Example
      Blur.IRC.part client, "#rockerboo"
      :ok
  """
  @spec part(client :: pid | atom, channel :: binary) :: :ok | {:error, atom}
  def part(client, channel) do
    Logger.debug("Part #{channel}")
    ExIRC.Client.part(client, channel)
  end

  def part(client, channel),
    do: part(client, channel)

  @doc """
  Send a message to the channel

  ## Example
      Blur.IRC.say :twitchirc, "#rockerboo", "Hello"
      :ok
  """
  @spec say(client :: pid | atom, channel :: binary, msg :: binary) :: :ok | {:error, atom}
  def say(client, channel, msg) do
    Logger.debug("Say #{client} #{channel}: #{msg}")
    ExIRC.Client.msg(client, :privmsg, channel, msg)
  end

  @doc """
  Quit the IRC server.

  ## Example
      Blur.IRC.quit client, "Goodbye!"
      :ok
  """
  @spec quit(client :: pid | atom, msg :: nil | binary) :: :ok | {:error, atom}
  def quit(client, msg) do
    ExIRC.Client.quit(client, msg)
  end

  @doc """
  Quit the IRC server with no message.

  ## Example
      Blur.IRC.quit client
      :ok
  """
  @spec quit(client :: pid | atom) :: :ok | {:error, atom}
  def quit(client) do
    quit(client, nil)
  end

  @doc """
  Stop the IRC client process

  ## Example
      Blur.IRC.stop! client
      {:stop, :normal, :ok, %ExIRC.Client{}}
  """
  @spec stop!(client :: pid | atom) :: {:stop, :normal, :ok, %ExIRC.Client.ClientState{}}
  def stop!(client) do
    ExIRC.Client.stop!(client)
  end
end
