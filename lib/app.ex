defmodule Blur.App do
  use Supervisor

  def start_link([user, channel]) do
    Supervisor.start_link(__MODULE__, [user, channel], name: :blur)
  end

  @spec start(atom, list) :: GenServer.on_start()
  def start(_type, [user, channels]) do
    Supervisor.start_link(__MODULE__, [user, channels], name: :blur)
  end

  @impl Supervisor
  def init([user, channels]) do
    {:ok, client} = ExIRC.start_link!()

    Process.register(client, :twitchirc)

    children = [
      {Blur.IRC.Connection, [:twitchirc, user]},
      {Blur.IRC.Login, [:twitchirc, channels]},
      {Blur.IRC.Channel, [:twitchirc]},
      {Blur.IRC.Message, [:twitchirc]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
