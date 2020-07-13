defmodule Blur.IRC.TwitchTag do
  @moduledoc """
  Handle all the following tags. 
  https://dev.twitch.tv/docs/irc/tags/

  # User
  display-name: The user’s display name
  badge-info: indicate the exact number of months the user has been a subscriber. 
  badges: Comma-separated list of chat badges and the version of each badge 
  color: Hexadecimal RGB color code; the empty string if it is never set.
  user-id: The user's ID.

  # Messages
  bits: (Sent only for Bits messages) The amount of cheer/Bits employed by the user.
  emote-sets: A comma-separated list of emotes, belonging to one or more emote sets.
  emotes: Information to replace text in the message with emote images. This can be empty.
  mod: 1 if the user has a moderator badge; otherwise, 0.
  room-id: The channel ID.
  tmi-sent-ts: Timestamp when the server received the message.

  # Channel
  followers-only: Followers-only mode. If enabled, controls which followers can chat. Valid values: -1 (disabled), 0 (all followers can chat), or a non-negative integer (only users following for at least the specified number of minutes can chat).
  r9k: R9K mode. If enabled, messages with more than 9 characters must be unique. Valid values: 0 (disabled) or 1 (enabled).
  slow: The number of seconds a chatter without moderator privileges must wait between sending messages.
  subs-only: Subscribers-only mode. If enabled, only subscribers and moderators can chat. Valid values: 0 (disabled) or 1 (enabled).

  # User Notice
  msg-id: The type of notice (not the ID). Valid values: sub, resub, subgift, anonsubgift, submysterygift, giftpaidupgrade, rewardgift, anongiftpaidupgrade, raid, unraid, ritual, bitsbadgetier.
  system-msg: The message printed in chat along with this notice.

  # Message Params
  msg-param-cumulative-months   (Sent only on sub, resub) The total number of months the user has subscribed. This is the same as msg-param-months but sent for different types of user notices.
  msg-param-displayName   (Sent only on raid) The display name of the source user raiding this channel.
  msg-param-login   (Sent on only raid) The name of the source user raiding this channel.
  msg-param-months  (Sent only on subgift, anonsubgift) The total number of months the user has subscribed. This is the same as msg-param-cumulative-months but sent for different types of user notices.
  msg-param-promo-gift-total  (Sent only on anongiftpaidupgrade, giftpaidupgrade) The number of gifts the gifter has given during the promo indicated by msg-param-promo-name.
  msg-param-promo-name  (Sent only on anongiftpaidupgrade, giftpaidupgrade) The subscriptions promo, if any, that is ongoing; e.g. Subtember 2018.
  msg-param-recipient-display-name  (Sent only on subgift, anonsubgift) The display name of the subscription gift recipient.
  msg-param-recipient-id  (Sent only on subgift, anonsubgift) The user ID of the subscription gift recipient.
  msg-param-recipient-user-name   (Sent only on subgift, anonsubgift) The user name of the subscription gift recipient.
  msg-param-sender-login  (Sent only on giftpaidupgrade) The login of the user who gifted the subscription.
  msg-param-sender-name   (Sent only on giftpaidupgrade) The display name of the user who gifted the subscription.
  msg-param-should-share-streak   (Sent only on sub, resub) Boolean indicating whether users want their streaks to be shared.
  msg-param-streak-months   (Sent only on sub, resub) The number of consecutive months the user has subscribed. This is 0 if msg-param-should-share-streak is 0.
  msg-param-sub-plan  (Sent only on sub, resub, subgift, anonsubgift) The type of subscription plan being used. Valid values: Prime, 1000, 2000, 3000. 1000, 2000, and 3000 refer to the first, second, and third levels of paid subscriptions, respectively (currently $4.99, $9.99, and $24.99).
  msg-param-sub-plan-name   (Sent only on sub, resub, subgift, anonsubgift) The display name of the subscription plan. This may be a default name or one created by the channel owner.
  msg-param-viewerCount   (Sent only on raid) The number of viewers watching the source channel raiding this channel.
  msg-param-ritual-name   (Sent only on ritual) The name of the ritual this notice is for. Valid value: new_chatter.
  msg-param-threshold   (Sent only on bitsbadgetier) The tier of the bits badge the user just earned; e.g. 100, 1000, 10000.
  """

  @doc """
  Convert twitch tags to a map.
  """
  @spec to_map(cmd :: binary) :: map
  def to_map(cmd) do
    Blur.Parser.Twitch.parse(cmd)
    |> Enum.reduce(%{}, fn [k, v], acc -> Map.put(acc, k, v) end)
  end

  @doc """
  Parse server string into parts

  ## Example 
      iex> Blur.IRC.TwitchTag.parse_server("red_stone_dragon!red_stone_dragon@red_stone_dragon.tmi.twitch.tv")
      {"red_stone_dragon","red_stone_dragon","red_stone_dragon.tmi.twitch.tv"}
  """
  @spec parse_server(connection_string :: binary) :: {binary, binary, binary}
  def parse_server(connection_string) do
    case String.split(connection_string, ["!", "@"]) do
      [user, nick, server] -> {user, nick, server}
      [server] -> {"", "", server}
    end
  end

  @doc """
  Parse out message from tagged message.
  """
  @spec parse_tagged_message(%ExIRC.Message{}) :: %ExIRC.Message{} | nil
  def parse_tagged_message(irc_message) do
    [connection, cmd, channel | msg] = Enum.at(irc_message.args, 0) |> String.split(" ")

    message = Enum.join(msg, " ")

    case parse_server(connection) do
      {user, nick, server} ->
        %ExIRC.Message{
          irc_message
          | args: [channel, String.slice(message, 1, String.length(message))],
            cmd: cmd,
            nick: nick,
            user: user,
            server: server
        }
    end
  end
end
