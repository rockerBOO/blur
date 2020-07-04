defmodule Blur do
  @moduledoc """
  Access your bot through Blur
  """

  require Logger

  @doc """
  Join a channel on the client IRC connection.

  ## Examples
      iex> Blur.join :blur_irc_client, "#channel"
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
      iex> Blur.leave :blur_irc_client, "#channel"
      {:error, :not_logged_in}
  """
  @spec leave(client :: GenServer.server(), channel :: binary) :: :ok | {:error, atom}
  def leave(client, channel),
    do: Blur.IRC.part(client, channel)

  @doc """

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
