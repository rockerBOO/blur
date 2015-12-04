defmodule Blur.Parser.Command do
  @moduledoc """
  Parses messages for commands
  """

  require Logger

  def parse("!" <> command), do: command
  def parse(message), do: nil

  def find(message, user, channel) do
    message = parse(message)
    message |> translate(channel)
  end

  def translate(message, channel) do
    message
    |> translate_alias(Blur.Channel.aliases(channel))
    |> translate_command(Blur.Channel.commands(channel))
  end

  def translate_alias(message, aliases) do
    case alias?(message, aliases) do
      true  -> alias_to_command(message, aliases)
      false -> message
    end
  end

  def alias?(message, aliases) do
    if aliases[message] do
      true
    else false end
  end

  def alias_to_command(message, aliases) do
    aliases[message]
  end

  def translate_command(command, commands) do
    commands[command]
  end
end
