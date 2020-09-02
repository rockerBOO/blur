defmodule Blur.Twitch.Tag do
  @spec parse(tags :: binary, msg :: binary) :: tuple
  def parse(tags, msg) do
    tags = Blur.Twitch.Parser.parse_tags(tags)

    [user, cmd, channel, msg] = parse_message(msg, tags)

    case cmd do
      "CLEARCHAT" -> clearchat(channel, user)
      "CLEARMSG" -> clearmsg(channel, msg, tags)
      "GLOBALUSERSTATE" -> globaluserstate(tags)
      "PRIVMSG" -> privmsg(channel, user, msg, tags)
      "ROOMSTATE" -> roomstate(channel, tags)
      "USERNOTICE" -> usernotice(channel, msg, tags)
      "USERSTATE" -> userstate(channel, msg, tags)
      "NOTICE" -> notice(channel, msg, tags)
    end
  end

  # :ronni!ronni@ronni.tmi.twitch.tv PRIVMSG #ronni :Kappa Keepo Kappa
  @spec parse_message(msg :: %ExIRC.Message{} | binary, tags :: map) :: list
  def parse_message(%ExIRC.Message{} = msg, tags) do
    Enum.join(msg.args, "") |> parse_message(tags)
  end

  def parse_message(msg, tags) when is_binary(msg) do
    [server, cmd | msg] = String.split(msg, " ")

    # take the channel off the top
    [channel | msg] = msg

    # user, cmd, channel, message
    [
      fetch_user!(server, tags),
      cmd,
      channel,
      parse_msg(msg)
    ]
  end

  def fetch_user!(nil, _tags), do: %{}

  def fetch_user!(server, tags) do
    case parse_server(server) do
      %{"name" => _} = user ->
        Blur.Twitch.User.from_tags(user, tags)

      _ ->
        %{}
    end
  end

  def parse_msg([]) do
    ""
  end

  def parse_msg(msg) when is_list(msg) do
    Enum.join(msg, " ") |> parse_msg()
  end

  def parse_msg(msg) when is_binary(msg) do
    String.trim(msg) |> String.to_charlist() |> tl() |> to_string()
  end

  def parse_server(":" <> _ = server) do
    Regex.named_captures(~r/:(?<user>\w+)!(?<nick>\w+)@(?<name>\w+)\.(?<server>.*)/, server)
  end

  def parse_server(server) do
    parse_server(":" <> server)
  end

  def clearchat(channel, user) do
    {:clearchat, channel, user}
  end

  def clearmsg(channel, msg, tags) do
    {:clearmsg, channel, msg, tags}
  end

  def globaluserstate(tags) do
    {:globaluserstate, tags}
  end

  def privmsg(channel, user, msg, tags) do
    {:privmsg, channel, user, msg, tags}
  end

  def roomstate(channel, tags) do
    {:roomstate, channel, tags}
  end

  def usernotice(channel, msg, tags) do
    {:usernotice, channel, msg, tags}
  end

  def userstate(channel, msg, tags) do
    {:userstate, channel, msg, tags}
  end

  def notice(channel, msg, tags) do
    {:notice, channel, msg, tags}
  end
end
