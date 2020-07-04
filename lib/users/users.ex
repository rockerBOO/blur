defmodule Blur.Users do
  @moduledoc """
  Manages the lists of users in each channel.
  """

  require Logger
  use GenServer
  alias Blur.User

  @spec start_link(users :: list) :: GenServer.on_start()
  def start_link(users \\ []) do
    GenServer.start_link(__MODULE__, users)
  end

  @impl GenServer
  @spec init({GenServer.server(), list}) :: {:ok, list}
  def init(users) do
    {:ok, users}
  end

  @doc """
  Add user
  """
  @spec(add_user(pid :: GenServer.server(), user :: %User{}) :: :ok, {:error, atom})
  def add_user(pid, user),
    do: GenServer.cast(pid, {:add_user, user})

  @doc """
  Remove user
  """
  @spec(remove_user(pid :: GenServer.server(), user :: %User{}) :: :ok, {:error, atom})
  def remove_user(pid, user),
    do: GenServer.cast(pid, {:remove_user, user})

  @doc """
  Get user
  """
  @spec find_user(pid :: GenServer.server(), user :: %User{}) :: %User{}
  def find_user(pid, user),
    do: GenServer.call(pid, {:find_user, user})

  @doc """
  Get users
  """
  @spec users(pid :: GenServer.server()) :: list | {:error, atom}
  def users(pid),
    do: GenServer.call(pid, {:users})

  # Handlers
  # -=-=-=-=-=-=-=-=-=

  @impl GenServer
  @spec handle_cast(
          {:add_user, user :: %User{}} | {:remove_user, user :: %User{}},
          state :: list
        ) :: {:noreply, list}
  def handle_cast({:add_user, user}, state),
    do: {:noreply, state ++ [user]}

  def handle_cast({:remove_user, user}, state),
    do: {:noreply, Enum.filter(state, fn u -> u !== user end)}

  @impl GenServer
  @spec handle_call(
          {:find_user, user :: %User{}} | {:users},
          from :: {pid, tag :: term},
          state :: list
        ) ::
          {:reply, reply :: %User{} | list, new_state :: list}
  def handle_call({:find_user, user}, _from, state),
    do: {:reply, Enum.find(state, %User{}, fn u -> u.name === user.name end), state}

  def handle_call({:users}, _from, state),
    do: {:reply, state, state}
end
