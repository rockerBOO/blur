defmodule Blur.Test do
  use ExUnit.Case
  doctest Blur

  test "connection to the Twitch server" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, _} = Blur.connect!("localhost", 6667)

    assert Blur.is_connected?() === false

    :ok = Blur.connect!("irc.chat.twitch.tv", 6667)

    assert Blur.is_connected?() === true
  end

  test "logon attempt" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.logon("oauth:haha", "800807")
  end

  test "attempt to send a me message" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.me("rockerboo", "slaps you with a large trout")
  end

  test "attempt join a twitch channel" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.join("#rockerboo")
  end

  test "attempt to leave a twitch channel" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.leave("#rockerboo")
  end

  test "attempt to say a message" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.say("#rockerboo", "yo")
  end

  test "get the list of users in a channel" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.users("#rockerboo")

    Blur.connect!("irc.chat.twitch.tv", 6667)

    {:error, :not_logged_in} = Blur.users("#rockerboo")
  end

  test "has users in a channel" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.has_user?("#rockerboo", "rockerboo")

    Blur.connect!("irc.chat.twitch.tv", 6667)

    {:error, :not_logged_in} = Blur.has_user?("#rockerboo", "rockerboo")
  end

  test "for a list of connected channels" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.channels()

    Blur.connect!("irc.chat.twitch.tv", 6667)

    {:error, :not_logged_in} = Blur.channels()
  end

  test "that we are logged on" do
    {:ok, _} = ExIRC.Client.start_link([], name: :twitchirc)

    {:error, :not_connected} = Blur.is_logged_on?()

    Blur.connect!("irc.chat.twitch.tv", 6667)

    assert false === Blur.is_logged_on?()
  end
end
