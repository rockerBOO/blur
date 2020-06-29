defmodule Blur.Parser.Twitch do
  def parse(msg) do
    String.split(msg, ";") |> Enum.map(fn s -> String.split(s, "=") end)
  end
end
