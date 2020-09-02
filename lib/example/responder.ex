defmodule Blur.BotExample.Responder do
  use Blur.Responder

  hear ~r/^!hello$/, msg do
    IO.inspect(msg)
    # reply(msg, "hello")
  end
end
