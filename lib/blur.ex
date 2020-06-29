defmodule Blur do
  @moduledoc """
  Access your bot through Blur
  """

  require Logger

  @doc """
  Join a channel.

  ## Examples
      iex> Blur.join "#channel"
      :ok
  """
  @spec join(channel :: binary) :: :ok | {:error, atom}
  def join(channel),
    do: join(:irc_client, channel)

  @doc """
  Join a channel on the client IRC connection.

  ## Examples
      iex> Blur.join client, "#channel"
      :ok
  """
  @spec join(pid | atom, binary) :: :ok | {:error, atom}
  def join(client, "#" <> _ = channel),
    do: Blur.IRC.join(client, channel)

  def join(client, channel),
    do: join(client, "#" <> channel)

  @doc """
  Leave a channel on the client IRC connection.

  ## Examples
      iex> Blur.leave client, "#channel"
      :ok
  """
  @spec leave(client :: pid, channel :: binary) :: :ok | {:error, atom}
  def leave(client, channel),
    do: Blur.IRC.part(client, channel)

  @doc """
  Leave a channel.

  ## Examples
      iex> Blur.leave "#channel"
      :ok
  """
  @spec leave(channel :: binary) :: :ok | {:error, atom}
  def leave(channel),
    do: leave(:irc_client, channel)

  @doc """
  Say a message to the channel.

  ## Examples
      iex> Blur.say "#channel", "a message to the channel"
      :ok
  """
  @spec say(channel :: charlist, msg :: charlist) :: :ok | {:error, atom}
  def say(channel, msg),
    do: Blur.IRC.say(:irc_client, channel, msg)

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
