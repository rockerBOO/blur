defmodule TmiMessage do
  defstruct server:  '',
            nick:    '',
            user:    '',
            host:    '',
            cmd:     '',
            args:    []
end