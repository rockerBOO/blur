defmodule Blur.IRC.Names do
  @moduledoc """
  Stores the names of the users in a channel
  """

  require Logger
  use GenServer

  @doc """
  Start name listener
  """
  @spec start_link(client :: pid) :: GenServer.on_start()
  def start_link(client) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl GenServer
  @spec init(client :: pid) :: {:ok, pid}
  def init(client) do
    ExIRC.Client.add_handler(client, self())
    {:ok, client}
  end

  @impl GenServer
  @spec handle_info(
          {:names_list, channel :: charlist, names :: charlist}
          | {:joined, channel :: charlist, user :: %ExIRC.SenderInfo{}}
          | {:parted, channel :: charlist, user :: %ExIRC.SenderInfo{}}
          | {:mode, charlist, charlist, user :: %ExIRC.SenderInfo{}},
          client :: pid
        ) ::
          {:noreply, client :: pid}
  def handle_info({:names_list, channel, names}, state) do
    Logger.debug("Names: #{channel} #{names}")

    {:noreply, state}
  end

  def handle_info({:joined, channel, user}, state) do
    Logger.debug("#{user.nick} joined #{channel} ")

    {:noreply, state}
  end

  def handle_info({:parted, channel, user}, state) do
    Logger.debug("#{user.nick} parted #{channel}")

    {:noreply, state}
  end

  # Catch-all for messages you don't care about
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
