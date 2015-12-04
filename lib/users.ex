defmodule Blur.Channel.Users do
  @moduledoc """
  Manages the lists of users in each channel
  """

  require Logger

  def start_link("#" <> _ = channel, process_opts \\ []) do
    GenServer.start_link(__MODULE__, [channel], process_opts)
  end

  def init([channel]) do
    table = ets_table(channel)

    table |> :ets.new([:ordered_set, :named_table, :public])

    {:ok, :ok}
  end

  def ets_table(channel) do
    String.to_atom(channel <> "_users")
  end

  def list("#" <> _ = channel) do
    table = ets_table(channel)

    table
    |> :ets.tab2list()
    |> Enum.map(fn ({name}) ->
      name
    end)
  end

  def add("#" <> _ = channel, user) do
    Logger.debug "Adding #{channel} #{user}"

    table = ets_table(channel)

    table |> :ets.insert_new({user})
  end

  def remove("#" <> _ = channel, user) do
    Logger.debug "Removing #{channel} #{user}"

    table = ets_table(channel)

    table |> :ets.delete(user)
  end
end
