defmodule Blur.Supervisor do
  @moduledoc """
  Blur App Supervisor
  """

  use Supervisor
  require Logger

  def start_link([]) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @spec start(atom, list) :: GenServer.on_start()
  def start(_type, opts) do
    start_link(opts)
  end

  @impl Supervisor
  def init(:ok) do
    children = [
      {Blur.Channels, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
