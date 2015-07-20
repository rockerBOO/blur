defmodule Blur.Env do
  defmodule Error do
    defexception [:message]
  end

	def fetch!(key) when is_atom(key) do
    case fetch(key) do
      value -> value
      error -> raise %Error{message: "Environmetal variable not found"}
    end
  end

  def fetch(key) when is_atom(key) do
    case key do
      :chat_key     -> System.get_env("TWITCH_CHAT_KEY")
      :access_token -> System.get_env("TWITCH_ACCESS_TOKEN")
      :username     -> System.get_env("TWITCH_USERNAME")
    end
  end
end