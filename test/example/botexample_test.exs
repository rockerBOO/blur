defmodule Blur.Example.BotExampleTest do
  use ExUnit.Case

  test "bot example" do
    {:ok, _} = Blur.BotExample.start_link(name: "800807", channels: [])
  end
end
