defmodule Blur.Env do
  @moduledoc """
  Helper for getting the environmental variable

  """

  @doc """
  Fetches the key
  Blur.Env.fetch!(:chat_key)
  """
  def fetch!(key) when is_atom(key) do
    case fetch(key) do
      value -> value
      error -> raise "Environmetal variable not found"
    end
  end

  @doc """
  DO NOT USE :D, yet.
  """
  def fetch(key) when is_atom(key) do
    case key do
      :chat_key     -> System.get_env("TWITCH_CHAT_KEY")
      :access_token -> System.get_env("TWITCH_ACCESS_TOKEN")
      :username     -> System.get_env("TWITCH_USERNAME")
    end
  end

  @doc """
  Used on startup to check if twitch environmental
  variables are setup.
  """
  def validate! do
    IO.inspect System.get_env("TWITCH_USERNAME")

    if System.get_env("TWITCH_USERNAME") == nil do
      raise "Environmetal variables not found"
    end
  end
end
