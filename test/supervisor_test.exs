defmodule Blur.SupervisorTest do
  use ExUnit.Case, async: true

  doctest Blur.Supervisor

  test "that the blur supervisor starts" do
    {:ok, pid} = Blur.Supervisor.start(:normal, [])

    assert pid
  end
end
