defmodule Blur.IRC.App do
  use Supervisor
  require Logger

  # ExIrc connection
  def start_irc_client do
    case ExIrc.Client.start_link([], name: :irc_client) do
      {:ok, irc_client} -> irc_client
    end
  end

  def start(_type, irc_args) do
    irc_client = start_irc_client

    Blur.Env.validate!

    children = [
      worker(ConCache, [[], [name: :channels_config]]),
      # IRC Handlers
      worker(Blur.IRCHandler.Connection, [irc_client, irc_args]),
      worker(Blur.IRCHandler.Login, [irc_client]),
      worker(Blur.IRCHandler.Message, [irc_client]),
      worker(Blur.IRCHandler.Channel, [irc_client]),
      worker(Blur.IRCHandler.Names, [irc_client]),
    ]

    opts = [strategy: :one_for_one, name: Elirc.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def terminate(_reason, _state) do
    # Quit the channel and close the underlying client connection when the process is terminating
    ExIrc.Client.quit :irc_client, "See ya later. Blur"
    ExIrc.Client.stop! :irc_client

    :ok
  end
end
