defmodule Blur.WS.Client do
  @moduledoc """
  Web Socket Client

  * Should move to events
  """

  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Blur.WS.Client)
  end

  def init([]) do
    {:ok, %{socket: connect!()}}
  end

  def get_chat_servers() do
    "https://api.twitch.tv/api/channels/rockerboo/chat_properties"
    |> HTTPoison.get!()
    |> Map.fetch!(:body)
    |> Poison.decode!()
    |> Map.fetch!("web_socket_servers")
  end

  def get_ws_server() do
    chat_servers = get_chat_servers()

    chat_servers
    |> Enum.shuffle
    |> hd
    |> String.split(":")
    |> List.first()
  end

  def connect!() do
    socket = Socket.Web.connect!(get_ws_server())

    socket |> Socket.Web.send!({:text, "CAP REQ twitch.tv/commands"})

    {:ok, _} = Blur.WS.Listener.start_link(socket)

    Blur.WS.Listener |> GenServer.cast(:listen)

    socket
  end

  def login() do
    Blur.WS.Client
    |> GenServer.call({:login, Blur.Env.fetch!(:username)})
  end

  def login(user, pass) do
    Blur.WS.Client |> GenServer.call({:login, user, pass})
  end

  def join(channel) do
    Blur.WS.Client |> GenServer.call({:join, channel})
  end

  def handle_call({:login, user, pass}, _from, state) do
    Logger.debug "Login as #{user} pass"

    state.socket |> Socket.Web.send!({:text, "PASS #{pass}"})
    state.socket |> Socket.Web.send!({:text, "NICK #{user}"})

    {:reply, :ok, state}
  end

  def handle_call({:login, user}, _from, state) do
    Logger.debug "Login as #{user}"

    state.socket |> Socket.Web.send!({:text, "PASS #{Blur.token}"})
    state.socket |> Socket.Web.send({:text, "NICK #{user}"})

    {:reply, :ok, state}
  end

  def handle_call({:join, channel}, _from, state) do
    state.socket |> Socket.Web.send!({:text, "JOIN #{channel}"})

    {:reply, :ok, state}
  end


end
