defmodule Blur do
  use Supervisor
  require Logger

  def init([state]) do
    {:ok, state}
  end

  # ExIrc connection
  def start_irc_client do
    case ExIrc.Client.start_link([], name: :irc_client) do
      {:ok, irc_client} -> irc_client
    end
  end

  def say(client, msg), do: client |> Blur.IRC.say(msg)
  def say(msg), do: Blur.IRC.say(msg)

  def join(channel), do: Blur.IRC.join(channel)
  def join(client, channel), do: client |> Blur.IRC.join(channel)

  def start(_type, _args) do
    irc_client = start_irc_client

    children = [
      # IRC Handlers
      worker(Blur.IRCHandler.Connection, [irc_client]),
      worker(Blur.IRCHandler.Login, [irc_client]),
      worker(Blur.IRCHandler.Message, [irc_client]),
    ]

    opts = [strategy: :one_for_one, name: Elirc.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def token do
    case Blur.Env.fetch!(:access_token) do
      nil -> Blur.Env.fetch!(:chat_key)
      token -> "oauth:" <> token
    end
  end

  def terminate(reason, state) do
    # Quit the channel and close the underlying client connection when the process is terminating
    ExIrc.Client.quit :irc_client, "See ya later. Blur"
    ExIrc.Client.stop! :irc_client
    :ok
  end
end
