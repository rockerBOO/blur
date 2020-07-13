defmodule Blur.App do
  use Supervisor

  def start! do
    Supervisor.start_link(__MODULE__, [], name: :blur)
  end

  @spec start(atom, list) :: GenServer.on_start()
  def start(_type, [user, channels]) do
    Supervisor.start_link(__MODULE__, [user, channels], name: :blur)
  end

  @impl Supervisor
  def init([user, channels]) do
    {:ok, client} = ExIRC.start_link!()

    children = [
      {Blur.Channels, []},
      {Blur.Users, []},
      # {Blur.IRC.Client, [client]},
      {Blur.IRC.Connection, [client, user]},
      {Blur.IRC.Login, [client, channels]},
      {Blur.IRC.Channel, [client]},
      {Blur.IRC.Message, [client]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
