defmodule Blur.AppTest do
  use ExUnit.Case

  test "that the blur supervisor starts" do
    {:ok, pid} = Blur.App.start(:normal, ["", []])
  end
end
