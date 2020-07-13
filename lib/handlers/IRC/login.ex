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
  # @spec init([pid, list]) :: {:ok, GenServer.server()}
  def init([client, channels]) do
    Client.add_handler(client, self())
    {:ok, %{client: client, autojoin: channels}}
  end

  @spec autojoin(client :: GenServer.server(), channels :: list) :: :ok | {:error, atom}
  def autojoin(client, channels) do
    client |> Blur.IRC.join_many(channels)
  end

  @doc """
  Handle login messages
  """
  @impl true
  @spec handle_info(:logged_in, map) :: {:noreply, list}
  def handle_info(:logged_in, state) do
    Logger.debug("Logged in as #{Blur.Env.fetch(:username)}")

    # Request Twitch Capabilities (tags)
    case Blur.IRC.request_twitch_capabilities(state.client) do
      {:error, _} -> Logger.error("Not connected to Twitch")
      :ok -> :ok
    end

    Logger.debug("Joining channels [#{Enum.join(state.autojoin, ", ")}]")

    case autojoin(state.client, state.autojoin) do
      {:error, :not_connected} -> Logger.error("Not connected to Twitch IRC.")
      :ok -> :ok
    end

    {:noreply, state}
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
