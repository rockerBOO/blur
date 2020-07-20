defmodule Blur.IRC do
  @moduledoc """
  Shortcuts for IRC options to auto join channels

  client is a process of `ExIRC.Client.start_link`
  """

  require Logger

  @doc """
  Request the CAP (capability) on the server

  ## Example
      Blur.IRC.cap_request client, [':twitch.tv/membership']
      :ok
  """

  def cap_request(_, []), do: :ok

  def cap_request(client, [h | t]) do
    case ExIRC.Client.cmd(client, "CAP REQ #{h}") do
      :ok -> cap_request(client, t)
      {:error, _} = error -> error
    end
  end

  @doc """
  Request twitch for capabilities

  ## Example
      Blur.IRC.request_twitch_capabilities :twitchirc
      :ok
  """
  @spec request_twitch_capabilities(client :: pid | atom) :: :ok | {:error, atom}
  def request_twitch_capabilities(client) do
    # Request capabilities before joining the channel

    requests = [":twitch.tv/membership", ":twitch.tv/commands", ":twitch.tv/tags"]

    case cap_request(client, requests) do
      :ok -> :ok
      {:error, _} = error -> error
    end
  end
end
