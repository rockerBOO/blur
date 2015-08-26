defmodule Blur.IRCHandler.Message do
  require Logger

  alias Blur.Command
  alias Blur.Parser.Message
  alias Blur.Channel

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    client |> ExIrc.Client.add_handler self

    {:ok, %{client: client}}
  end

  # Handles messages sent from IRC
  def handle_info({:received, msg, user, channel}, state) do
    Logger.debug "#{channel} #{user}: #{msg}"

    if Channel.has_config?(channel) do
      case Message.parse(msg, user, channel)
           |> Command.run(user, channel) do
        {:error, error} -> Logger.error error
        :ok -> Logger.debug "Command send properly"
        nil -> Logger.debug "No command to run"
      end
    end

    {:noreply, state}
  end

  # Drop uncaught messages
  def handle_info(_info, state) do
    {:noreply, state}
  end

  def terminate(reason, _state) do
    IO.inspect reason

    :ok
  end
end