defmodule Blur.Channel.Config do
  @moduledoc """

  Config for the channel
  - Loads from a data file in blur/data/#channel/x.json
  """

  require Logger

  @doc """
  Load config from a json file.
  """
  @spec load_from_json(channel :: binary, type :: binary) :: Poison.Parser.t | no_return | nil
  def load_from_json("#" <> channel, type),
    do: load_from_json(channel, type)

  def load_from_json(channel, type) do
    case File.read("data/#{channel}/#{type}.json") do
      {:ok, body} -> body |> Poison.decode!()
      {:error, :enoent} -> nil
    end
  end
end
