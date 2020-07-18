defmodule Blur do
  @moduledoc """
  Access your bot through Blur

  Client

  Handlers
  - Login
  on_logon -> join_channels
  - Connection
  %ConnState{}
  on_connection -> login
  on_disconnection -> logoff
  - Message
  pool
  - Channels
  on_join -> add_channel
  [Channel, Channel]
  - Users
  on_names -> add_users
  on_user_join -> add_user
  on_part -> remove_user
  [User, User]
  """

  require Logger

  @doc """
  Join a channel on the client IRC connection.

  ## Examples
    
    Blur.join "#channel"
    :ok
  """
  @spec join(channel :: binary) :: :ok | {:error, atom}
  def join(channel),
    do: ExIRC.Client.join(:twitchirc, channel)

  @doc """
  Leave a channel on the client IRC connection.

  ## Examples
      
    Blur.leave "#channel"
  """
  @spec leave(channel :: binary) :: :ok | {:error, atom}
  def leave(channel),
    do: ExIRC.Client.part(:twitchirc, channel)

  @doc """
  Say a message to the channel.

  ## Examples
      Blur.say "#rockerboo", "yo"
  """
  @spec say(channel :: binary, message :: binary) ::
          :ok | {:error, atom}
  def say(channel, message),
    do: ExIRC.Client.msg(:twitchirc, :privmsg, channel, message)

  @doc """
  List who is in the channel. This is not completely accurate.

  ## Examples
      Blur.users "#rockerboo"
  """
  @spec users(channel :: binary) :: list | {:error, atom}
  def users(channel),
    do: ExIRC.Client.channel_users(:twitchirc, channel)

  @doc """
  List channels we have joined.

  ## Examples
      Blur.channels 
  """
  @spec channels() :: list | {:error, atom}
  def channels(),
    do: ExIRC.Client.channels(:twitchirc)

  @doc """
  Check if we are logged on.

  ## Examples
      Blur.is_logged_on? 
  """
  @spec is_logged_on?() :: boolean
  def is_logged_on?(),
    do: ExIRC.Client.is_logged_on?(:twitchirc)

  @doc """
  Get token from the environmental variables.
  """
  @spec token() :: nil | binary
  def token do
    case Blur.Env.fetch!(:access_token) do
      nil -> Blur.Env.fetch!(:chat_key)
      token -> "oauth:" <> token
    end
  end
end
