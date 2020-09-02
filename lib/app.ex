defmodule Blur.App do
  @moduledoc """
  Blur Application.

  Start ExIRC Client

  * Listen for:
  - Connections
  - Login
  - Messages
  """

  use Application

  @impl true
  @spec start(atom, list) :: {:error, atom} | {:ok, pid()}
  def start(_type, _args) do
    # validate environmental variables
    System.fetch_env!("TWITCH_CLIENT_KEY")

    Supervisor.start_link(Blur.Supervisor, [])
  end
end
