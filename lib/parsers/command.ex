defmodule Blur.Parser.Command do
  @moduledoc """
  Parses messages for commands
  """

  require Logger
  alias Blur.Channel

  def parse("!" <> command), do: command
  def parse(_message), do: nil

  def find(message) do
    parse(message)
  end

  # Blur.Channel.aliases(channel)
  # Blur.Channel.commands(channel)

  def translate(message, user, "#" <> _ = channel) do
    { aliases, commands } = Channel.translation(channel)

    translated = translate_alias(message, aliases)

    translated |> translate_command(commands)
  end

  def translate(message, user, channel) do
    translate(message, user, "##{channel}")
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
    else
      false
    end
  end

  def alias_to_command(message, aliases) do
    aliases[message]
  end

  def translate_command(command, commands) do
    commands[command]
  end
end
