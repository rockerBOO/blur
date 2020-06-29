defmodule Blur.IRC.Login do
  @moduledoc """
  Handle the IRC login messages
  """

  require Logger
  use GenServer
  alias ExIRC.Client

  @doc """
  Start login handler
  """
  @spec start_link(list) :: GenServer.on_start()
  def start_link([client, channels]) do
    GenServer.start_link(__MODULE__, [client, channels])
  end

  @impl true
  @spec init(list) :: {:ok, list}
  def init([client, channels]) do
    Client.add_handler(client, self())
    {:ok, [client, channels]}
  end

  @doc """
  Handle user login
  """
  @impl true
  @spec handle_info(:logged_in, list) :: {:noreply, list}
  def handle_info(:logged_in, [client, channels]) do
    Logger.debug("Logged in as #{Blur.Env.fetch(:username)}")

    Blur.IRC.request_twitch_capabilities(client)

    Logger.debug("Joining channels #{Enum.join(channels, ", ")}")
    Blur.IRC.join_many(client, channels)

    Logger.debug("Start channels ...")
    Blur.IRC.Channel.start_link(client)

    Logger.debug("Start messages ...")
    Blur.IRC.Message.start_link(client)

    {:noreply, [client, channels]}
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
