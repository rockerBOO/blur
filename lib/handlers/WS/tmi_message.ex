defmodule TmiMessage do
  defstruct server:  '',
            nick:    '',
            user:    '',
            host:    '',
            cmd:     '',
            ctcp:    nil,
            args:    []
end