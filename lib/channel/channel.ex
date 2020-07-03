defmodule Blur.Channel do
  @moduledoc """
  Channel module
  """
  defmodule State do
    defstruct channel: "", client: nil, config?: nil, users: nil
  end

  use GenServer
  require Logger
  alias Blur.User

  @spec start_link(channel :: binary, users :: list) :: GenServer.on_start()
  def start_link(channel, users \\ []) do
    GenServer.start_link(__MODULE__, {channel, users})
  end

  @impl GenServer
  def init({channel, users}) do
    # config? = load_config(channel)

    {:ok, users} = Blur.Users.start_link(channel, users)

    {:ok, %State{channel: channel, users: users}}
  end

  @doc """
  Add user
  """
  @spec(add_user(users :: GenServer.server(), user :: %User{}) :: :ok, {:error, atom})
  def add_user(users, user),
    do: GenServer.cast(users, {:add_user, user})

  @doc """
  Remove user
  """
  @spec(remove_user(users :: GenServer.server(), user :: %User{}) :: :ok, {:error, atom})
  def remove_user(users, user),
    do: GenServer.cast(users, {:remove_user, user})

  @doc """
  Get user
  """
  @spec(user(users :: GenServer.server(), user :: %User{}) :: :ok, {:error, atom})
  def user(pid, user),
    do: GenServer.call(pid, {:user, user})

  @doc """
  Get users
  """
  @spec users(users :: GenServer.server()) :: %User{} | {:error, atom}
  def users(users),
    do: GenServer.call(users, {:users})

  @impl true
  @spec handle_cast(
          {:add_user, user :: %User{}} | {:remove_user, user :: %User{}},
          state :: %State{}
        ) :: {:noreply, %State{}}
  def handle_cast({:add_user, user}, state),
    do: {:noreply, %{state | users: Map.put(state.users, user.name, user)}}

  def handle_cast({:remove_user, user}, state),
    do: {:noreply, %{state | users: Map.delete(state.users, user.name)}}

  @impl true
  @spec handle_call(
          {:user, user :: %User{}} | {:users},
          from :: {pid, tag :: term},
          state :: %State{}
        ) ::
          {:reply, reply :: %User{} | list, new_state :: %State{}}
  def handle_call({:user, user}, _from, state),
    do: {:reply, state.users[user.nick], state}

  def handle_call({:users}, _from, state),
    do: {:reply, state.users, state}
end
