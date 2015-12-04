defmodule Blur.Parser.Message do
  @moduledoc """
  Parses the message and finds commands??

  * Fix flow
  """

  alias   Blur.Parser.Command
  require Logger


  # Blur.Channel.aliases(channel)
  # Blur.Channel.commands(channel)
  def parse(channel, user, message) do
    message
    |> Command.find()
    |> Command.translate(channel, user)
  end
end
