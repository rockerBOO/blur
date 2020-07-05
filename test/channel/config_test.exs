defmodule Blur.Channel.ConfigTest do
  use ExUnit.Case, async: true

  doctest Blur.Channel.Config
  alias Blur.Channel.Config

  test "load config from file" do
    %{} = Config.load_from_file("#someonewhodoesntexist", "config")
  end
end
