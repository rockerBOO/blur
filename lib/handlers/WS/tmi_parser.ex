# github.com/bitwalker/exirc/lib/exirc/utils.ex

defmodule Blur.TMI.Parser do
  ######################
  # TMI Message Parsing
  ######################

  @doc """
  Parse an TMI message
  Example:
      data    = ':irc.example.org 005 nick NETWORK=Freenode PREFIX=(ov)@+ CHANTYPES=#&'
      message = Blur.TMI.Parser.parse data
      assert "irc.example.org" = message.server
  """
  @spec parse(raw_data :: char_list) :: TmiMessage.t
  def parse(raw_data) do
    data = :string.substr(raw_data, 1, length(raw_data))
    case data do
      [?:|_] ->
          [[?:|from]|rest] = :string.tokens(data, ' ')
          get_cmd(rest, parse_from(from, %TmiMessage{ctcp: false}))
      data ->
          get_cmd(:string.tokens(data, ' '), %TmiMessage{ctcp: false})
    end
  end

  @split_pattern ~r/(!|@|\.)/
  defp parse_from(from, msg) do
    from_str = IO.iodata_to_binary(from)
    splits   = Regex.scan(@split_pattern, from_str, return: :index)
               |> Enum.map(fn [{start, len},_] -> binary_part(from_str, start, len) end)
    parts    = Regex.split(@split_pattern, from_str)
    woven    = weave(splits, parts)
    case woven do
      [nick, "!", user, "@" | host] ->
        %{msg | :nick => nick, :user => user, :host => Enum.join(host)}
      [nick, "@" | host] ->
        %{msg | :nick => nick, :host => Enum.join(host)}
      [_, "." | _] ->
        # from is probably a server name
        %{msg | :server => to_string(from)}
      [nick] ->
        %{msg | :nick => nick}
    end
  end

  # Parse command from message
  defp get_cmd([cmd, arg1, [?:, 1 | ctcp_trail] | restargs], msg) when cmd == 'PRIVMSG' or cmd == 'NOTICE' do
    get_cmd([cmd, arg1, [1 | ctcp_trail] | restargs], msg)
  end

  defp get_cmd([cmd, target, [1 | ctcp_cmd] | cmd_args], msg) when cmd == 'PRIVMSG' or cmd == 'NOTICE' do
    args = cmd_args
      |> Enum.map(&Enum.take_while(&1, fn c -> c != 0o001 end))
      |> Enum.map(&List.to_string/1)
    case args do
      args when args != [] ->
        %{msg |
          :cmd  => to_string(ctcp_cmd),
          :args => [to_string(target), args |> Enum.join(" ")],
          :ctcp => true
        }
      _ ->
        %{msg | :cmd => to_string(cmd), :ctcp => :invalid}
    end
  end

  defp get_cmd([cmd | rest], msg) do
    get_args(rest, %{msg | :cmd => to_string(cmd)})
  end

  # Parse command args from message
  defp get_args([], msg) do
    args = msg.args
      |> Enum.reverse
      |> Enum.filter(fn(arg) -> arg != [] end)
      |> Enum.map(&trim_crlf/1)
      |> Enum.map(&List.to_string/1)
    %{msg | :args => args}
  end

  defp get_args([[?: | first_arg] | rest], msg) do
    args = (for arg <- [first_arg | rest], do: ' ' ++ trim_crlf(arg)) |> List.flatten
    case args do
      [_ | []] ->
          get_args [], %{msg | :args => [msg.args]}
      [_ | full_trail] ->
          get_args [], %{msg | :args => [full_trail | msg.args]}
    end
  end

  defp get_args([arg | []], msg) do
    get_args [], %{msg | :args => [arg | msg.args]}
  end

  defp get_args([arg | rest], msg) do
    get_args rest, %{msg | :args => [arg | msg.args]}
  end

  defp trim_crlf(charlist) do
    case Enum.reverse(charlist) do
      [?\n, ?\r | text] -> Enum.reverse(text)
      _ -> charlist
    end
  end

  defp weave(xs, ys), do: do_weave(xs, ys, [])
  defp do_weave([], ys, result),           do: (ys ++ result) |> Enum.reverse
  defp do_weave(xs, [], result),           do: (xs ++ result) |> Enum.reverse
  defp do_weave([hx|xs], [hy|ys], result), do: do_weave(xs, ys, [hx, hy | result])
end