defmodule Blur.Parser.Message do
  alias   Blur.Parser.Command
  require Logger

  def parse(message, user, channel) do
    message
    |> Command.find(user, channel)
  end
end