defmodule Blur.Users do
  @moduledoc """
  Manages the lists of users in each channel.
  """

  defmodule Blur.User do
    defstruct name: "",
              opts: %{}
  end

  require Logger
  use GenServer

  @spec start_link(channel :: binary) :: GenServer.on_start()
  def start_link(channel, users \\ []) do
    GenServer.start_link(__MODULE__, {channel, users})
  end

  @impl true
  @spec init({GenServer.server(), list}) :: {:ok, %{channel: GenServer.server(), users: list}}
  def init({channel, users}) do
    {:ok, %{channel: channel, users: users}}
  end
end
