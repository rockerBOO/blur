defmodule Blur.Channel.Users do
  require Logger

  def start_link("#" <> _ = channel, process_opts \\ []) do
    GenServer.start_link(__MODULE__, [channel], process_opts)
  end

  def init([channel]) do
    ets_table(channel)
    |> :ets.new([:ordered_set, :named_table, :public])

    {:ok, :ok}
  end

  def ets_table(channel) do
    String.to_atom(channel <> "_users")
  end

  def list("#" <> _ = channel) do
    ets_table(channel)
    |> :ets.tab2list()
    |> Enum.map(fn ({name}) ->
      name
    end)
  end

  def add("#" <> _ = channel, user) do
    Logger.debug "Adding #{channel} #{user}"

    ets_table(channel)
    |> :ets.insert_new({user})
  end

  def remove("#" <> _ = channel, user) do
    Logger.debug "Removing #{channel} #{user}"

    ets_table(channel)
    |> :ets.delete(user)
  end
end