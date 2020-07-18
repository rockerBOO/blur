defmodule Blur.Parser.Twitch do
  @moduledoc """
  Parse Twitch messages
  """

  @doc """
  Parse tag messages into parts.

  ## Examples
  """
  @spec parse_tags(msg :: binary) :: map
  def parse_tags(msg) do
    String.split(msg, ";")
    |> Enum.map(fn s -> String.split(s, "=") end)
    |> Enum.map(fn [k, v] -> %{k => v} end)
    |> Enum.reduce(fn acc, m -> Map.merge(acc, m) end)
  end
end
