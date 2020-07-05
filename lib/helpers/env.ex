defmodule Blur.Env do
  @moduledoc """
  Helper for getting the environmental variable
  """

  @doc """
  Fetches the key

  ## Example

    Blur.Env.fetch!(:username)
    "800807"
  """
  def fetch!(key) when is_atom(key) do
    case fetch(key) do
      "" -> raise "Environmetal variable not found"
      value -> value
    end
  end

  @doc """
  Get the keys from the system variables
  """
  def fetch(key) when is_atom(key) do
    case key do
      :chat_key -> System.get_env("TWITCH_CHAT_KEY")
      :access_token -> System.get_env("TWITCH_ACCESS_TOKEN")
      :username -> System.get_env("TWITCH_USERNAME")
      _ -> ""
    end
  end
end
