defmodule Blur do
  @moduledoc """
  Access your bot through Blur
  """

  require Logger

  @doc """
  Connect to the Twitch server. 

  ## Example
      Blur.connect!("tmi.twitch.tv", 6667)
  """
  @spec connect!(server :: binary, port :: non_neg_integer()) :: :ok
  def connect!(server, port),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.connect!(server, port, [])

  @doc """
  Are we connected to the server? 

  ## Example
      Blur.is_connected?()
  """
  @spec is_connected?() :: true | false
  def is_connected?(),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.is_connected?()

  @doc """
  Logon to the Twitch server. 
  This happens automatically on connection to Twitch using Blur.App 

  ## Example
      Blur.logon "oauth:hashhereforyourpassword928", "rockerboo"
  """
  @spec logon(pass :: binary, name :: binary) :: :ok | {:error, :not_connected}
  def logon("oauth:" <> _ = pass, name),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.logon(pass, name, name, name)

  @doc """
  Send a /me message to the channel.

  ## Example
      Blur.me "#rockerboo", "slaps you with a large trout." 
  """
  @spec me(channel :: binary, msg :: binary) :: :ok | {:error, atom}
  def me(channel, msg),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.me(channel, msg)

  @doc """
  Join a channel on the client IRC connection.

  ## Examples
      Blur.join "#channel"
  """
  @spec join(channel :: binary) :: :ok | {:error, atom}
  def join(channel),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.join(channel)

  @doc """
  Leave a channel on the client IRC connection.

  ## Examples
      Blur.leave "#channel"
  """
  @spec leave(channel :: binary) :: :ok | {:error, atom}
  def leave(channel),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.part(channel)

  @doc """
  Say a message to the channel.

  ## Examples
      Blur.say "#rockerboo", "yo"
  """
  @spec say(channel :: binary, message :: binary) ::
          :ok | {:error, atom}
  def say(channel, message),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.msg(:privmsg, channel, message)

  @doc """
  List who is in the channel. This is not completely accurate.

  ## Examples
      Blur.users "#rockerboo"
  """
  @spec users(channel :: binary) :: list | {:error, atom}
  def users(channel),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.channel_users(channel)

  @doc """
  Is a user in a channel? Case-sensitive, all lower case

  ## Examples
      Blur.has_user? "#rockerboo", "rockerboo"
  """
  @spec has_user?(channel :: binary, name :: binary) :: true | false | {:error, atom}
  def has_user?(channel, name),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.channel_has_user?(channel, name)

  @doc """
  List channels we have joined.

  ## Examples
      Blur.channels()
  """
  @spec channels() :: list | {:error, atom}
  def channels(),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.channels()

  @doc """
  Check if we are logged on.

  ## Examples
      Blur.is_logged_on?()
  """
  @spec is_logged_on?() :: boolean
  def is_logged_on?(),
    do: Process.whereis(:twitchirc) |> ExIRC.Client.is_logged_on?()

  @doc """
  Get token from the environmental variables.
  """
  @spec token() :: nil | binary
  def token do
    case System.get_env("TWITCH_ACCESS_TOKEN") do
      nil -> System.get_env("TWITCH_CHAT_KEY")
      token -> "oauth:" <> token
    end
  end
end
