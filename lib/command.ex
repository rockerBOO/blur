defmodule Blur.Command do
  require Logger

  def run(nil, _, _), do: nil
  def run(command, user, channel) do
    case command do
      ["say", message] -> Blur.say(channel, message)
      ["cmd", cmd]     -> IO.inspect cmd
      _                -> nil
    end
  end
end