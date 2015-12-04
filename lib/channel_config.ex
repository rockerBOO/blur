defmodule Blur.Channel.Config do
  @moduledoc """

    Config for the channel
    - Loads from a data file in blur/data/#channel/x.json
  """

  require Logger

  def load_channel_config(channel) do
    load(channel, ["config", "commands", "aliases"])

    # check if commands were loaded for channel
    if config_loaded?(channel) do
      Logger.info "Loaded config for #{channel}"
      true
    else
      false
    end
  end

  def load(_channel, []), do: :ok
  def load(channel, [type | remaining]) do
    channel |> load_from_json(type) |> save(channel, type)

    load(channel, remaining)
  end

  def load_from_json("#" <> channel, type) do
    case File.read "data/#{channel}/#{type}.json" do
      {:ok, body}       -> body |> Poison.decode!()
      {:error, :enoent} -> nil
    end
  end

  def get(key) do
    case ConCache.get(:channels_config, key) do
      nil -> nil
      value -> value |> Poison.decode!()
    end
  end

  def save(data, channel, type) do
    if data != nil do
      put(:channels_config, "#{channel}-#{type}", data |> Poison.encode!())
    end
  end

  def put(table, key, value) do
    ConCache.put(table, key, value)
  end

  def config_loaded?(channel) do
    cache = ConCache.ets(:channels_config)
    cache |> :ets.member("#{channel}-config")
  end
end
