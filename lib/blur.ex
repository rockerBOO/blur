defmodule Blur do
  require Logger

  def say(client, msg),
  do: client |> Blur.IRC.say(msg)

  def say(msg),
  do: Blur.IRC.say(msg)

  def join("#" <> _ = channel),
  do: Blur.IRC.join(channel)

  def join(channel),
  do: join("#" <> channel)

  def join(client, "#" <> _ = channel),
  do: client |> Blur.IRC.join(channel)

  def join(client, channel),
  do: join(client, "#" <> channel)

  def token do
    case Blur.Env.fetch!(:access_token) do
      nil -> Blur.Env.fetch!(:chat_key)
      token -> "oauth:" <> token
    end
  end
end
