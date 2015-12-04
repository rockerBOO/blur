defmodule TmiMessage do
  @moduledoc """
  Stores the Twitch Message Interface Message

    server:  '',
    nick:    '',
    user:    '',
    host:    '',
    cmd:     '',
    ctcp:    nil,
    args:    []

  """

  defstruct server:  '',
            nick:    '',
            user:    '',
            host:    '',
            cmd:     '',
            ctcp:    nil,
            args:    []
end
