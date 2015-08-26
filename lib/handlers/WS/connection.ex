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

  def connect_hitbox() do
    {:ok, proc} = start_link("ec2-54-87-101-9.compute-1.amazonaws.com", "/socket.io/1/websocket/5JlUTJiM9w-VT1i_v_ef")

    IO.inspect proc
  end

  def join(channel) do
    Blur.WS.Connection |> GenServer.call({:join, channel})
  end

  def handle_call({:join, channel}, _from, state) do
    # 5:::{"name":"message","args":[{"method":"joinChannel","params":{"channel":"namaee","name":"UnknownSoldier","token":null,"isAdmin":false}}]}

    loginMessage = %{
      "name" => "message",
      "args" => [
        %{
          "method" => "joinChannel",
          "params" => %{"channel" => channel, "name" => "UnknownSoldier", "token" => nil, "isAdmin" => false}
        }
      ]
    }

    message = "5:::" <> Poison.encode!(loginMessage)

    IO.puts "Message"
    IO.inspect message

    socket = Keyword.get(state, :socket)

    socket |> Socket.Web.send!({:text, message})
    response = socket |> Socket.Web.recv!()

    IO.puts "Response"
    IO.inspect response

    {:reply, :ok, state}
  end

  def handle_info(msg, state) do
    IO.inspect msg

    {:noreply, state}
  end
end

# Socket.Web.connect! "ec2-54-87-101-9.compute-1.amazonaws.com", [:active, path: "/socket.io/1/websocket/T9fiV85n6RWZCU3dwBfI"]