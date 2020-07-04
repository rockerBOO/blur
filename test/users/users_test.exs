defmodule Blur.UsersTest do
  use ExUnit.Case

  doctest Blur.Users
  alias Blur.User

  test "Add user" do
    pid = start_supervised!({Blur.Channel, []})

    assert :ok === Blur.Channel.add_user(pid, %User{name: "rockerboo"})
  end

  test "Remove user" do
    pid = start_supervised!({Blur.Channel, []})

    assert :ok === Blur.Channel.remove_user(pid, %User{name: "rockerboo"})

    assert Blur.Channel.user(pid, %User{name: "rockerboo"})
  end

  test "user" do
    pid = start_supervised!({Blur.Channel, []})

    Blur.Channel.add_user(pid, %User{name: "rockerboo"})

    assert %User{name: "rockerboo"} === Blur.Channel.user(pid, %User{name: "rockerboo"})
  end

  test "users" do
    pid = start_supervised!({Blur.Channel, []})

    Blur.Channel.add_user(pid, %User{name: "rockerboo"})
    Blur.Channel.add_user(pid, %User{name: "adattape"})

    assert [%User{name: "rockerboo"}, %User{name: "adattape"}] === Blur.Channel.users(pid)
  end
end
