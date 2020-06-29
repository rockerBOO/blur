defmodule Blur.IRC.Connection.State do
  @moduledoc """
  IRC connection state
  """

  defstruct host: "irc.twitch.tv",
            port: 6667,
            nick: "",
            user: "",
            name: "",
            debug?: true,
            client: nil
end
