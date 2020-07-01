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
  @spec start_link(pid) :: GenServer.on_start()
  def start_link(client) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl true
  @spec init(pid) :: {:ok, pid}
  def init(client) do
    Client.add_handler(client, self())
    {:ok, client}
  end

  @spec autojoin(client :: pid) :: :ok
  def autojoin(client) do
    client |> Blur.IRC.join_many(Application.get_env(:blur, :autojoin))
  end

  @doc """
  Handle user login
  """
  @impl true
  @spec handle_info(:logged_in, list) :: {:noreply, list}
  def handle_info(:logged_in, client) do
    Logger.debug("Logged in as #{Blur.Env.fetch(:username)}")

    Blur.IRC.request_twitch_capabilities(client)

    Logger.debug("Joining channels #{Enum.join(Application.get_env(:blur, :autojoin), ", ")}")
    autojoin(client)

    {:noreply, client}
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
