defmodule Blur.Connection.State do
  @moduledoc """
  Holds the connection state data

    host: "irc.twitch.tv",
    port: 6667,
    nick: "",
    user: "",
    name: "",
    debug?: true,
    client: nil

  """

  defstruct host: "irc.twitch.tv",
            port: 6667,
            nick: "",
            user: "",
            name: "",
            debug?: true,
            client: nil
end
