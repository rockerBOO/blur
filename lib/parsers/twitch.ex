defmodule Blur.Parser.Twitch do
  @moduledoc """
  Parse Twitch messages
  """

  @doc """
  Parse tag messages into parts.

  ## Examples
  """
  @spec parse(msg :: binary) :: list
  def parse(msg) do
    String.split(msg, ";") |> Enum.map(fn s -> String.split(s, "=") end)
  end
end
