defmodule Blur.IRC.Names do
  @moduledoc """
  Stores the names of the users in a channel
  """

  require Logger
  use GenServer

  alias Blur.Channel

  @doc """
  Start name listener
  """
  @spec start_link(client :: pid) :: GenServer.on_start()
  def start_link(client) do
    GenServer.start_link(__MODULE__, client)
  end

  @impl true
  @spec init(client :: pid) :: {:ok, pid}
  def init(client) do
    ExIRC.Client.add_handler(client, self())
    {:ok, client}
  end

  @impl true
  @spec handle_info({:names_list, channel :: charlist, names :: list}, client :: pid) ::
          {:noreply, client :: pid}
  def handle_info({:names_list, channel, names}, state) do
    String.split(names, " ")
    |> Enum.each(fn name ->
      Channel.add_user(channel, name)
    end)

    {:noreply, state}
  end

  @spec handle_info({:joined, channel :: charlist, name :: charlist}, client :: pid) ::
          {:noreply, client :: pid}
  def handle_info({:joined, channel, name}, state) do
    Logger.debug("Joined #{channel} #{name}")

    Channel.add_user(channel, name)

    {:noreply, state}
  end

  @spec handle_info({:parted, channel :: charlist, name :: charlist}, client :: pid) ::
          {:noreply, client :: pid}
  def handle_info({:parted, channel, name}, state) do
    Logger.debug("Parted #{channel} #{name}")

    Channel.remove_user(channel, name)

    {:noreply, state}
  end

  @spec handle_info({:mode, charlist, charlist}, client :: pid) :: {:noreply, client :: pid}
  def handle_info({:mode, channel, op, name}, state) do
    Logger.debug("#{channel} #{op} #{name}")
    {:noreply, state}
  end

  # Catch-all for messages you don't care about
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
