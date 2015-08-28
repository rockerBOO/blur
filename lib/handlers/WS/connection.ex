defmodule Blur.WS.Connection do
  def start_link(server, path) do
    GenServer.start_link(__MODULE__, [server, path], name: Blur.WS.Connection)
  end

  def init([server, path]) do
    socket = Socket.Web.connect!(server, [:active, path: path])

    response = socket |> Socket.Web.recv!()

    IO.puts "Connection Response"
    IO.inspect response

    {:ok, [socket: socket]}
  end


  def handle_info(msg, state) do
    IO.inspect msg

    {:noreply, state}
  end
end