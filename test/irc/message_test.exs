defmodule Blur.IRC.MessageTest do
  use ExUnit.Case, async: true
  doctest Blur.IRC.Message

  alias Blur.IRC.Message

  describe "on receiving an IRC message" do
    test "for private message" do
      irc_client = start_supervised({ExIRC.Client, []})

      {:noreply, state} =
        Message.handle_info(
          {:received, "Private message", %ExIRC.SenderInfo{nick: "rockerboo"}},
          irc_client
        )

      assert state === irc_client
    end

    test "for message to channel" do
      irc_client = start_supervised({ExIRC.Client, []})

      {:noreply, state} =
        Message.handle_info(
          {:received, "Private message", %ExIRC.SenderInfo{}, "rockerboo"},
          irc_client
        )

      assert state === irc_client
    end
  end

  describe "on unrecognized " do
    test "for code 366" do
      irc_client = start_supervised({ExIRC.Client, []})

      {:noreply, state} =
        Message.handle_info(
          {:unrecognized, "366", %ExIRC.SenderInfo{}},
          irc_client
        )

      assert state === irc_client
    end

    test "for code CAP" do
      irc_client = start_supervised({ExIRC.Client, []})

      {:noreply, state} =
        Message.handle_info(
          {:unrecognized, "CAP", %ExIRC.SenderInfo{}},
          irc_client
        )

      assert state === irc_client
    end

    test "for Twitch tags" do
      irc_client = start_supervised({ExIRC.Client, []})

      {:noreply, state} =
        Message.handle_info(
          {:unrecognized, "display-name=rockerBOO connection cmd channel msg",
           %ExIRC.Message{
             args: ["@display-name=rockerBOO;color=434554; connection cmd channel msg"]
           }},
          irc_client
        )

      assert state === irc_client
    end
  end
end
