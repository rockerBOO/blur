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
    
    Blur.join :twitch, "#channel"
    :ok
  """
  @spec join(client :: GenServer.server(), channel :: binary) :: :ok | {:error, atom}
  def join(client, "#" <> _ = channel),
    do: join(client, channel)

  def join(client, channel),
    do: Blur.IRC.join(client, channel)

  @doc """
  Leave a channel on the client IRC connection.

  ## Examples
      
    Blur.leave :twitch, "#channel"
  """
  @spec leave(client :: GenServer.server(), channel :: binary) :: :ok | {:error, atom}
  def leave(client, channel),
    do: Blur.IRC.part(client, channel)

  @doc """
  Say a message to the channel.

  ## Examples

      Blur.say :twitch, "adattape"
  """
  def say(client, channel, message),
    do: Blur.IRC.say(client, channel, message)

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
