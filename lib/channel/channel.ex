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

  def get_users_pid(pid),
    do: GenServer.call(pid, :users)

  def add_user(pid, user),
    do: get_users_pid(pid) |> Users.add_user(user)

  def remove_user(pid, user),
    do: get_users_pid(pid) |> Users.remove_user(user)

  @spec users(pid :: GenServer.server()) :: list | {:error, atom}
  def users(pid), do: get_users_pid(pid) |> Users.users()

  def user(pid, name), do: get_users_pid(pid) |> Users.user(name)

  @impl GenServer
  def handle_call(:users, _from, state),
    do: {:reply, state.users, state}
end
