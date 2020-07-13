defmodule Blur.IRC.ConnectionTest do
  use ExUnit.Case, async: true
  doctest Blur.IRC.Connection

  alias Blur.IRC.Connection.State
  alias Blur.IRC.Connection

  # test "on connecting to the IRC server" do
  #   {:noreply, state} =
  #     Connection.handle_info(
  #       {:connected, "localhost", 6667},
  #       %State{}
  #     )

  #   assert state === %State{}
  # end

  describe "on disconnecting from the channel" do
    test "regular IRC" do
      {:noreply, state} = Connection.handle_info({:disconnected}, %State{})

      assert state === %State{}
    end

    test "Twitch Tags" do
      {:noreply, state} =
        Connection.handle_info({:disconnected, "@display-name=rockerBOO"}, %State{})

      assert state === %State{}
    end
  end
end
