defmodule Blur do
  def start_bot(bot, opts) do
    Blur.Supervisor.start_bot(bot, opts)
  end

  def stop_bot(bot) do
    Blur.Supervisor.stop_bot(bot)
  end
end
