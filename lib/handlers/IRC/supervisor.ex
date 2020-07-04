defmodule Blur.IRC.Supervisor do
  @moduledoc """
  Blur IRC App Supervisor

  Children
  * ConCache
  * Blur.IRC.Connection
  * Blur.IRC.Login
  """

  use Supervisor
  require Logger
  alias ExIRC.Client

  def start_link() do
    {:ok, irc_client} = Client.start_link()

    Supervisor.start_link(__MODULE__, irc_client)
  end

  @spec start(module, list) :: GenServer.on_start()
  def start(_type, opts) do
    {:ok, irc_client} = Client.start_link()

    Supervisor.start_link(__MODULE__, irc_client, opts)
  end

  @impl true
  def init(irc_client) do
    children = [
      {ConCache, [name: :channel_cache, ttl_check_interval: false]},
      {Blur.IRC.Connection, irc_client},
      {Blur.IRC.Login, irc_client},
      {Blur.IRC.Channel, irc_client},
      {Blur.IRC.Message, irc_client}
      # {Blur.IRC.Names, irc_client}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def terminate(_reason, irc_client) do
    # Quit the channel and close the underlying client
    # connection when the process is terminating
    Blur.IRC.quit(irc_client)
    Blur.IRC.stop!(irc_client)

    Logger.info("Closed IRC connection.")

    :ok
  end
end
