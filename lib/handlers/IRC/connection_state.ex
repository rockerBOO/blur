defmodule Blur.Connection.State do
  defstruct host: "irc.twitch.tv",
            port: 6667,
            nick: "",
            user: "",
            name: "",
            debug?: true,
            client: nil
end