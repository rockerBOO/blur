defmodule Blur.Twitch.ParserTest do
  use ExUnit.Case

  doctest Blur.Twitch.Parser
  alias Blur.Twitch.Parser

  describe "parse twitch tags into parts" do
    test "demo data" do
      assert %{"x" => "y", "a" => "b"} === Parser.parse_tags("x=y;a=b;")
    end

    test "display-name" do
      assert %{"display-name" => "rockerBOO"} === Parser.parse_tags("display-name=rockerBOO;")
    end
  end
end
