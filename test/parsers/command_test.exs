defmodule Blur.Parser.CommandTest do
  use ExUnit.Case
  doctest Blur.Parser.Command

  test "find command" do
    assert Blur.Parser.Command.command("!command") == "command"
    assert Blur.Parser.Command.command("command") == nil
  end
end
