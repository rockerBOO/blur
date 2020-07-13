defmodule Blur.IRC.LoginTest do
  use ExUnit.Case, async: true
  doctest Blur.IRC.Login

  test "on logged in" do
    irc_client = start_supervised!({ExIRC.Client, []})

    {:noreply, _} = Blur.IRC.Login.handle_info(:logged_in, %{client: irc_client, autojoin: []})
  end

  test "to autojoin channels in the config" do
    irc_client = start_supervised!({ExIRC.Client, []})

    :ok = Blur.IRC.Login.autojoin(irc_client, ["rockerboo"])
  end
end
