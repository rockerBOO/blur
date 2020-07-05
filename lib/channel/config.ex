defmodule Blur.Channel.Config do
  @moduledoc """

  Config for the channel
  - Loads from a data file in data/#channel/x.json
  """

  require Logger

  @doc """
  Load config from a json file.
  """
  @spec load_from_file(channel :: binary, type :: binary) :: Poison.Parser.t() | no_return | nil
  def load_from_file("#" <> channel, type),
    do: load_from_file(channel, type)

  def load_from_file(channel, type) do
    case File.read("data/#{channel}/#{type}.json") do
      {:ok, body} -> body |> Poison.decode!()
      {:error, :enoent} -> %{}
      {:error, error} -> IO.inspect(error)
    end
  end
end
