defmodule Blur.Command do
  @moduledoc """

    Processor of commands (right now)
  """

  require Logger

  def run(nil, _, _), do: nil
  def run(command, user, channel) do
    case command do
      ["say", message] -> Blur.say(channel, message)
      ["cmd", "song"]  ->
        {artist, _, title} =
          Blur.Lastfm.get_last_played()
        Blur.say(channel, "#{artist} - #{title}")
      ["cmd", cmd]     -> IO.inspect cmd
      _                -> nil
    end
  end
end
