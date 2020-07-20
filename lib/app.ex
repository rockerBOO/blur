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
  @spec start(atom, list) :: {:error, atom} | {:ok, pid}
  def start(_type, [user, channels]) do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    children = [
      {Blur.IRC.Connection, [:twitchirc, user]},
      {Blur.IRC.Login, [:twitchirc, channels]},
      {Blur.IRC.Message, [:twitchirc]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: :blur)
  end
end
