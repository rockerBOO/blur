defmodule Blur.Channel do
  @moduledoc """
  Channel module
  """

  use GenServer
  require Logger
  alias Blur.Channel.Config

  defmodule State do
    defstruct channel: "",
              client: nil,
              config?: nil,
              users: []
  end

  defmodule Error do
    @moduledoc """
      Channel errors
    """
    defexception [:message]
  end

  @spec to_atom(channel :: binary) :: atom
  def to_atom("#" <> channel), do: String.to_atom(channel)
  def to_atom(channel), do: to_atom("#" <> channel)

  @doc """
  Start channel store
  """
  @spec start_link(client :: pid, channel :: binary) :: GenServer.on_start()
  def start_link(client, "#" <> _ = channel) do
    GenServer.start_link(
      __MODULE__,
      {client, channel}
    )
  end

  def start_link(client, channel), do: start_link(client, "#" <> channel)

  @impl true
  @spec init(tuple) :: {:ok, %State{}}
  def init({client, channel}) do
    config? = channel |> Config.load_channel_config()

    {:ok, users} = Blur.Channel.Users.start_link(channel)

    {:ok, %State{channel: channel, client: client, config?: config?, users: users}}
  end

  @doc """
  Add user to channel

  ## Examples
      iex> Blur.Channel.add_user "#rockerboo", "rockerBOO"
      :ok
  """
  @spec add_user(channel :: binary, user :: binary) :: :ok
  def add_user(channel, user) do
    to_atom(channel) |> GenServer.cast({:add_user, user})
  end

  @doc """
  Remove user from the channel

  ## Examples
      iex> Blur.Channel.remove_user "#rockerboo", "rockerBOO"
      :ok
  """
  @spec remove_user(channel :: binary, user :: binary) :: :ok
  def remove_user(channel, user) do
    to_atom(channel) |> GenServer.cast({:remove_user, user})
  end

  @doc """
  Get users in a channel

  ## Examples
      iex> Blur.Channel.users "#rockerboo"
      ["rockerBOO"]
  """
  @spec users(channel :: binary) :: :ok
  def users(channel) do
    to_atom(channel) |> GenServer.call(:users)
  end

  @doc """
  Get config for a channel

  ## Examples
      iex> Blur.Channel.config? "#rockerboo"
      %{}
  """
  @spec config?(channel :: binary) :: nil | map
  def config?(channel) do
    to_atom(channel) |> GenServer.call(:config?)
  end

  @doc """
  Get commands for a channel

  ## Examples
      iex> Blur.Channel.commands "#rockerboo"
      %{}
  """
  @spec commands(channel :: binary) :: list
  def commands(channel) do
    to_atom(channel) |> GenServer.call(:commands)
  end

  @doc """
  Get aliases for a channel

  ## Examples
      iex> Blur.Channel.aliases "#rockerboo"
      %{}
  """
  @spec aliases(channel :: binary) :: list
  def aliases(channel) do
    to_atom(channel) |> GenServer.call(:aliases)
  end

  @doc """
  Handle channel info
  """
  @impl true
  @spec handle_call(:aliases | :commands | :config? | :users, tuple, %State{}) ::
          {:reply, nil | map | list, %State{}}
  def handle_call(:aliases, _from, state),
    do: {:reply, Config.get("#{state.channel}-aliases"), state}

  def handle_call(:commands, _from, state),
    do: {:reply, Config.get("#{state.channel}-commands"), state}

  def handle_call(:config?, _from, state),
    do: {:reply, state.config?, state}

  def handle_call(:users, _from, state),
    do: {:reply, Blur.Channel.Users.list(state.channel), state}

  @doc """
  Handle channel users
  """
  @impl true
  @spec handle_cast({:add_user | :remove_user, user :: binary}, %State{}) :: {:noreply, %State{}}
  def handle_cast({:add_user, user}, state) do
    Blur.Channel.Users.add(state.channel, user)

    {:noreply, state}
  end

  def handle_cast({:remove_user, user}, state) do
    Blur.Channel.Users.remove(state.channel, user)

    {:noreply, state}
  end
end
