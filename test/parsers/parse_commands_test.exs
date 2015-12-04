defmodule BlurParseCommandsTest do
  use ExUnit.Case
  alias Blur.Parser.Command

  @message "!hi"
  @user "BluurrBot"
  @channel "rockerBOO"

  @aliases %{"hi" => "hello"}
  @commands %{"hello" => ["say", "Hello"]}

  test "translate aliases" do
    message  = Command.find(@message)

    assert "hello" == message
      |> Command.translate_alias(@aliases)
  end

  test "is alias" do
    assert Command.alias?("hi", @aliases)
    assert false === Command.alias?("hello", @aliases)
  end

  test "translate command" do
    message = Command.find(@message)

    assert ["say", "Hello"] == message
    |> Command.translate_alias(@aliases)
    |> Command.translate_command(@commands)
  end

  test "find command in message" do
    assert "hi" ==
      Command.find(@message)
  end

end
