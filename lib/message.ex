defmodule Blur.Message do
  @moduledoc """

  """

  defstruct bot: nil,
            ref: nil,
            mod: false,
            channel: "",
            roomid: "",
            type: "",
            system: "",
            user: nil,
            tags: [],
            text: ""
end
