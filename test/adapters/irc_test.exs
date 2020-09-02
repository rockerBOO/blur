defmodule Blur.Adapter.IRCTest do
  use ExUnit.Case

  alias Blur.Adapter.IRC

  test "CAP requests" do
    client = start_supervised!(ExIRC.Client)

    IRC.request_twitch_capabilities(client)
  end

  test "incoming message routing" do
    client = start_supervised!(ExIRC.Client)
    bot = Blur.BotExample

    cmd = "@;"

    {:noreply, {bot, _, _}} =
      IRC.handle_info(
        {:unrecognized, cmd, %ExIRC.Message{}},
        {bot, [], client}
      )
  end

  test "incoming notice" do
    {:noreply, nil} = IRC.handle_info({:notice, "#rockerboo", "rockerboo", "notice message"}, nil)
  end
end
