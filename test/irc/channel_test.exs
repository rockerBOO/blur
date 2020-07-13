defmodule Blur.IRC.ChannelTest do
  use ExUnit.Case, async: true
  doctest Blur.IRC.Channel

  test "on joining the IRC channel" do
    irc_client = start_supervised!({ExIRC.Client, []})

    {:noreply, state} = Blur.IRC.Channel.handle_info({:joined, "rockerboo"}, irc_client)

    assert irc_client === state
  end

  test "on someone joining the IRC channel" do
    irc_client = start_supervised!({ExIRC.Client, []})

    {:noreply, state} =
      Blur.IRC.Channel.handle_info({:joined, "rockerboo", %ExIRC.SenderInfo{}}, irc_client)

    assert irc_client === state
  end

  test "to start and exit IRC channel process" do
    irc_client = start_supervised!({ExIRC.Client, []})

    pid = start_supervised!({Blur.IRC.Channel, [irc_client]})

    Process.exit(pid, :kill)

    Process.sleep(1)

    refute Process.alive?(pid)
  end
end
