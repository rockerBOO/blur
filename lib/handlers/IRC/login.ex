defmodule Blur.IRCHandler.Login do
  require Logger

  def start_link(client) do
    GenServer.start_link(__MODULE__, [client])
  end

  def init([client]) do
    ExIrc.Client.add_handler client, self
    {:ok, %{client: client}}
  end

  def handle_info(:logged_in, state) do
    Logger.debug "Logged in as #{Blur.Env.fetch(:username)}"

    state.client |> Blur.IRC.request_twitch_capabilities
    autojoin

    {:noreply, state}
  end

  def autojoin() do
    Application.get_env(:blur, :autojoin, [])
    |> Blur.IRC.join_many
  end

  # Drops unknown messages
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def terminate(reason, _state) do
    IO.inspect reason

    :ok
  end
end