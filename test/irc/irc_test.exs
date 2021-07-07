defmodule Blur.IRCTest do
  use ExUnit.Case, async: true
  doctest Blur.IRC

  test "request twitch capbilities" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.IRC.request_twitch_capabilities(:twitchirc)

    Blur.connect!("irc.chat.twitch.tv", 6667)

    {:error, :not_logged_in} = Blur.IRC.request_twitch_capabilities(:twitchirc)
  end
end
