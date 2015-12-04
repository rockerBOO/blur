defmodule Blur.Channel do
  @moduledoc """
  Channel module

    users(channel)
    add_user(channel, user)
    channel_to_atom("#channel")
    has_config?(channel)
    commands(channel)
    aliases(channel)

  """

  require Logger
  alias Blur.Channel.Config

  defmodule Error do
    @moduledoc """
      Channel errors
    """
    defexception [:message]
  end

  def start_link("#" <> _ = channel) do
    GenServer.start_link(__MODULE__,
      [channel],
      [name: channel_to_atom(channel)]
    )
  end

  def start_link(channel), do: start_link("#" <> channel)

  def init([channel]) do
    config? = channel |> Config.load_channel_config

    {:ok, users} = Blur.Channel.Users.start_link(channel)

    {:ok, %{channel: channel, config?: config?, users: users}}
  end

  def add_user(channel, user) do
    atom = channel_to_atom(channel)
    atom
    |> GenServer.cast({:add_user, user})
  end

  def remove_user(channel, user) do
    atom = channel_to_atom(channel)
    atom |> GenServer.cast({:remove_user, user})
  end

  def users(channel) do
    atom = channel_to_atom(channel)
    atom |> GenServer.call(:users)
  end

  def channel_to_atom("#" <> channel), do: String.to_atom(channel)
  def channel_to_atom(channel), do: channel_to_atom("#" <> channel)

  def config?(channel) do
    atom = channel_to_atom(channel)
    atom |> GenServer.call(:config?)
  end

  def commands(channel) do
    atom = channel_to_atom(channel)
    atom |> GenServer.call(:commands)
  end

  def aliases(channel) do
    atom = channel_to_atom(channel)
    atom |> GenServer.call(:aliases)
  end

  def handle_call(:aliases, _from, state),
  do: {:reply, Config.get("#{state.channel}-aliases"), state}

  def handle_call(:commands, _from, state),
  do: {:reply, Config.get("#{state.channel}-commands"), state}

  def handle_call(:config?, _from, state),
  do: {:reply, state.config?, state}

  def handle_call(:users, _from, state) do
    {:reply, Blur.Channel.Users.list(state.channel), state}
  end

  def handle_cast({:add_user, user}, state) do
    Blur.Channel.Users.add(state.channel, user)

    {:noreply, state}
  end

  def handle_cast({:remove_user, user}, state) do
    Blur.Channel.Users.remove(state.channel, user)

    {:noreply, state}
  end
end
