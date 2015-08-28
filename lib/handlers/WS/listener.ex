defmodule Blur.WS.Listener do
  require Logger

  def start_link(socket) do
    GenServer.start_link(__MODULE__, [socket], name: Blur.WS.Listener)
  end

  def init([socket]) do
    {:ok, %{socket: socket}}
  end

  def msg([channel, msg], user) do
    Logger.debug "#{channel} #{user} #{msg}"
  end

  def action([channel, action]) do
    Logger.debug "Action: #{channel} #{action}"
  end

  def timed_out([channel, user]) do
    Logger.debug "Timed out: #{channel} #{user}"
  end

  def parse_msg(text) do
    msg = Blur.TMI.Parser.parse(String.to_char_list(text))

    # IO.inspect msg

    case msg.cmd do
      "PRIVMSG"   -> msg(msg.args, msg.nick)
      "ACTION"    -> action(msg.args)
      "CLEARCHAT" -> timed_out(msg.args)
      _           -> IO.inspect msg
    end
  end

  def handle_cast(:listen, state) do
    case state.socket |> Socket.Web.recv!() do
      {:text, text} -> parse_msg(text)
      msg -> IO.inspect msg
    end

    self |> GenServer.cast(:listen)

    {:noreply, state}
  end
end