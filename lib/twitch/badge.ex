defmodule Blur.Twitch.Badge do
  @doc """
  Parse badges into badges map

  "subscriber/0,premium/1" |> %{"subscriber" => "0", "premium" => "1"}
  """
  def parse(""), do: []

  def parse(badges) when is_binary(badges) do
    String.split(badges, ",")
    |> Enum.map(fn badge -> String.split(badge, "/") |> parse() end)
    |> parse(Map.new())
  end

  # Map key value list into tuple
  def parse([k, v]) do
    {k, v}
  end

  @doc """
  Parses a list of  badges to get them into a map.

  [["subscriber", "1"]] |> %{"subscriber" => "1"}
  """
  @spec parse(list, map) :: map
  def parse([], acc), do: acc

  def parse([{k, v} | rest], acc) do
    parse(rest, Map.put(acc, k, v))
  end
end
