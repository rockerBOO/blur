defmodule Blur.Twitch.Parser do
  @moduledoc """
  Parse Twitch messages
  """

  @doc """
  Parse tag messages into parts.

  ## Examples
  """
  @spec parse_tags(msg :: binary) :: map
  def parse_tags("@" <> tags = _) do
    parse_tags(tags)
  end

  def parse_tags(msg) do
    String.split(msg, ";")
    |> Enum.map(fn s -> String.split(s, "=") end)
    |> Enum.map(fn opts ->
      case opts do
        [k, v] -> %{k => String.trim(v)}
        [k, v, v2] -> %{k => [String.trim(v), v2]}
        _ -> %{}
      end
    end)
    |> Enum.reduce(fn acc, m -> Map.merge(acc, m) end)
  end

  def parse_message([msg]) do
    parse_message(msg)
  end

  def parse_message(msg) do
    case String.split(msg, " ") do
      [server, "PRIVMSG", channel, msg] -> [server, "PRIVMSG", channel, msg]
      uncaught -> IO.inspect(uncaught)
    end
  end
end
