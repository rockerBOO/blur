defmodule Blur do
  @moduledoc """
  Wrapper for client functions

    Short to sent to a random channel, Ideally just 1.
    say(client, "Hello!")



  """

  require Logger

  # To say to the client irc connection
  def say(client, msg),
  do: client |> Blur.IRC.say(msg)


  # To say to a RANDOM irc connection
  def say(msg),
  do: Blur.IRC.say(msg)

  # To say to a channel '#rockerboo'
  def join("#" <> _ = channel),
  do: Blur.IRC.join(channel)

  # To join a channel on a RANDOM irc connection
  def join(channel),
  do: join("#" <> channel)

  # To join a channel on the client irc connection
  def join(client, "#" <> _ = channel),
  do: client |> Blur.IRC.join(channel)

  # Join a channel on the client irc connection
  def join(client, channel),
  do: join(client, "#" <> channel)

  # Get token from the Environmental Variables
  def token do
    case Blur.Env.fetch!(:access_token) do
      nil -> Blur.Env.fetch!(:chat_key)
      token -> "oauth:" <> token
    end
  end
end
