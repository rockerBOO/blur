defmodule Blur.Parser.Command do
  @moduledoc """
  Parses messages for commands
  """

  def command("!" <> command), do: command
  def command(_message), do: nil
end
