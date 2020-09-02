defmodule Blur.Notice do
  @type t :: %__MODULE__{
          id: binary,
          channel: binary,
          text: binary,
          system_msg: binary,
          type: binary,
          login: binary,
          mod: boolean,
          subscriber: boolean,
          badges: list,
          tags: map
        }

  defstruct id: "",
            channel: "",
            text: "",
            system_msg: "",
            type: "",
            mod: false,
            subscriber: false,
            login: "",
            badges: [],
            tags: %{}

  @spec from_tags(channel :: binary, text :: binary, tags :: map) :: %Blur.Notice{}
  def from_tags(channel, text, tags) do
    %Blur.Notice{
      id: tags["id"],
      channel: channel,
      text: text,
      type: tags["msg-id"],
      system_msg: tags["system-msg"],
      mod: tags["mod"] |> Blur.Twitch.User.to_boolean(),
      subscriber: tags["subscriber"] |> Blur.Twitch.User.to_boolean(),
      login: tags["login"],
      badges: tags["badges"] |> Blur.Twitch.Badge.parse(),
      tags: tags
    }
  end
end
