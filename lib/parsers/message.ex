defmodule Blur.Parser.Message do
  @moduledoc """
  Parses the message and finds commands??

  * Fix flow
  """

  alias   Blur.Parser.Command
  require Logger

  def parse(message, user, channel) do
    message
    |> Command.find(user, channel)
  end
end
