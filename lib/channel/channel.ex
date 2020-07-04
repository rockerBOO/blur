defmodule Blur.Channel do
  @moduledoc """
  Channel module
  """
  defmodule State do
    defstruct channel: "", client: nil, config?: nil, users: nil
  end

  use GenServer
  require Logger
  alias Blur.Users
  alias Blur.User

  @spec start_link(channel :: binary, users :: list) :: GenServer.on_start()
  def start_link(channel, users \\ []) do
    GenServer.start_link(__MODULE__, {channel, users})
  end

  @impl GenServer
  def init({channel, users}) do
    # config? = load_config(channel)

    {:ok, users} = Blur.Users.start_link(users)

    {:ok, %State{channel: channel, users: users}}
  end

  @doc """
  Get users process is from channel process
  """
  @spec get_users_pid(pid :: GenServer.server()) :: GenServer.server()
  def get_users_pid(pid),
    do: GenServer.call(pid, :users)

  @doc """
  Add user to channel
  """
  @spec add_user(pid :: GenServer.server(), user :: %User{}) :: :ok
  def add_user(pid, user),
    do: get_users_pid(pid) |> Users.add_user(user)

  @doc """
  Remove user from channel
  """
  @spec remove_user(pid :: GenServer.server(), user :: %User{}) :: :ok
  def remove_user(pid, user),
    do: get_users_pid(pid) |> Users.remove_user(user)

  @doc """
  Get users in channel
  """
  @spec users(pid :: GenServer.server()) :: list | {:error, atom}
  def users(pid), do: get_users_pid(pid) |> Users.users()

  @doc """
  Find user in channel
  """
  @spec find_user(pid :: GenServer.server(), name :: %User{}) :: %User{}
  def find_user(pid, name), do: get_users_pid(pid) |> Users.find_user(name)

  # Handlers
  # -=-=-=-=-=-=-=-=-=

  @impl GenServer
  def handle_call(:users, _from, state),
    do: {:reply, state.users, state}
end
