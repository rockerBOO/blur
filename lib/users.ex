defmodule Blur.Channel.Users do
  @moduledoc """
  Manages the lists of users in each channel.
  """

  require Logger
  use GenServer

  @spec start_link(channel :: binary) :: GenServer.on_start()
  def start_link("#" <> _ = channel) do
    GenServer.start_link(__MODULE__, [channel])
  end

  @impl true
  @spec init(list) :: {:ok, binary}
  def init([channel]) do
    table = ets_table(channel)

    table |> :ets.new([:ordered_set, :named_table, :public])

    {:ok, channel}
  end

  @spec ets_table(channel :: binary) :: atom
  def ets_table(channel) do
    String.to_atom("users" <> channel)
  end

  @spec list(channel :: binary) :: list
  def list("#" <> _ = channel) do
    table = ets_table(channel)

    table
    |> :ets.tab2list()
    |> Enum.map(fn {name} ->
      name
    end)
  end

  @spec add(channel :: binary, user :: binary) :: boolean | [tuple]
  def add("#" <> _ = channel, user) do
    Logger.debug("Adding #{channel} #{user}")

    table = ets_table(channel)

    table |> :ets.insert_new({user})
  end

  @spec remove(channel :: binary, user :: binary) :: boolean | term
  def remove("#" <> _ = channel, user) do
    Logger.debug("Removing #{channel} #{user}")

    table = ets_table(channel)

    table |> :ets.delete(user)
  end
end
