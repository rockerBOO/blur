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
  @spec start_link(GenServer.server()) :: GenServer.on_start()
  def start_link(client) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl GenServer
  @spec init(client :: GenServer.server()) :: {:ok, GenServer.server()}
  def init(client) do
    Client.add_handler(client, self())
    {:ok, client}
  end

  @spec autojoin(client :: GenServer.server()) :: :ok
  def autojoin(client) do
    client |> Blur.IRC.join_many(Application.get_env(:blur, :autojoin))
  end

  @doc """
  Handle login messages
  """
  @impl GenServer
  @spec handle_info(:logged_in, list) :: {:noreply, list}
  def handle_info(:logged_in, client) do
    Logger.debug("Logged in as #{Blur.Env.fetch(:username)}")

    Logger.debug("Joining channels [#{Enum.join(Application.get_env(:blur, :autojoin), ", ")}]")
    autojoin(client)

    {:noreply, client}
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
