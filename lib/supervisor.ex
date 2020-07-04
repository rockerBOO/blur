defmodule Blur.Supervisor do
  @moduledoc """
  Blur App Supervisor
  """

  use Supervisor
  require Logger

  @spec start(atom, list) :: GenServer.on_start()
  def start(_type, opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {Blur.Channels, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def terminate(_reason, _state) do
    Logger.info("Terminate blur application.")

    :ok
  end
end
