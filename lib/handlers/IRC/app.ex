defmodule Blur.IRC.App do
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

  @spec start(atom, list) :: GenServer.on_start
  def start(_type, opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  @spec init(:ok) :: {:ok, tuple}
  def init(:ok) do
    {:ok, irc_client} = Client.start_link()

    # Register :irc_client for easy access for commands. Better idea?
    Process.register(irc_client, :irc_client)

    children = [
      worker(ConCache, [[], [name: :channels_config]]),
      {Blur.IRC.Connection, [irc_client]},
      {Blur.IRC.Login, [irc_client, ["#rockerboo", "#firstcrimson"]]}
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
