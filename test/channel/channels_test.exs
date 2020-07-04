defmodule Blur.ChannelsTest do
  use ExUnit.Case
  alias Blur.Channels

  doctest Blur.Channels

  test "to add channel to channels" do
    pid = start_supervised!({Blur.Channels, []})

    assert :ok === Channels.add(pid, "rockerboo")
  end

  test "to delete channel from channels" do
    pid = start_supervised!({Blur.Channels, []})

    assert :ok = Channels.add(pid, "rockerboo")

    assert :ok === Channels.delete(pid, "rockerboo")
  end

  test "to find channel in channels" do
    pid = start_supervised!({Blur.Channels, []})

    assert :ok = Channels.add(pid, "rockerboo")

    assert {"rockerboo", _} = Channels.find(pid, "rockerboo")

    assert nil === Channels.find(pid, "adattape")
  end

  test "to list all channels" do
    pid = start_supervised!({Blur.Channels, []})

    assert :ok = Channels.add(pid, "rockerboo")
    assert :ok = Channels.add(pid, "adattape")

    assert [{"rockerboo", _}, {"adattape", _}] = Channels.channels(pid)
  end
end
