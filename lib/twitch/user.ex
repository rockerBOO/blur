defmodule Blur.Twitch.User do
  @type t :: %__MODULE__{
          id: binary,
          name: binary,
          display_name: binary,
          color: binary,
          mod: boolean,
          subscriber: boolean,
          badges: list
        }

  defstruct display_name: "",
            name: "",
            id: "",
            color: "",
            mod: false,
            subscriber: false,
            badges: []

  @spec to_boolean(str :: binary, default :: boolean) :: boolean
  def to_boolean(str, default \\ false) do
    case str do
      "1" -> true
      "0" -> false
      _ -> default
    end
  end

  @spec from_tags(user :: map, map :: %{}) :: %Blur.Twitch.User{}
  def from_tags(user, map) do
    %Blur.Twitch.User{
      id: map["user-id"],
      name: user["name"],
      display_name: map["display-name"],
      mod: map["mod"] |> to_boolean(),
      subscriber: map["subscriber"] |> to_boolean(),
      color: map["color"],
      badges: map["badges"] |> Blur.Twitch.Badge.parse()
    }
  end
end
