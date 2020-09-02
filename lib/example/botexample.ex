defmodule Blur.BotExample do
  use Blur.Bot
  require Logger

  def handle_in(%Blur.Message{} = msg, state) do
    Logger.debug("#{msg.channel} #{msg.user.display_name}: #{msg.text}")
    {:dispatch, msg, state}
  end

  def handle_in(%Blur.Notice{} = notice, state) do
    IO.inspect(notice)
    Logger.info("#{notice.channel} #{notice.type} #{notice.login}: #{notice.text}")
    {:dispatch, notice, state}
  end
end
