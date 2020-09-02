defmodule Blur.Supervisor do
  @moduledoc """
  Manages the dynamic supervisors.

  DynamicSupervisors:
  - Blur.BotSupervisor
  - Blur.ResolverSupervisor

  ## Start a new bot
  Blur.BotExample uses Blur.Bot.

  ## Examples
      iex> Blur.Supervisor.start_bot(Blur.BotExample, name: "botexample", channels: [])

  """
  use Supervisor
  require Logger

  @spec start_link(list) :: GenServer.on_start()
  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  Start the bot.
  This adds the bot to the supervisor.

  ## Examples
      iex> Blur.Supervisor.start_bot(Blur.BotExample, name: "botexample", channels: [])
  """
  @spec start_bot(bot :: atom, opts :: list) :: Supervisor.on_start_child()
  def start_bot(bot, opts) do
    DynamicSupervisor.start_child(Blur.BotSupervisor, {Blur.Bot, [bot, opts]})
  end

  @doc """
  Stop the bot.
  Stops the child on the supervisor to properly shut down.

  ## Examples
      iex> Blur.Supervisor.stop_bot(Blur.BotExample)
  """
  @spec stop_bot(atom) :: :ok
  def stop_bot(bot) do
    DynamicSupervisor.stop(bot)
  end

  @impl true
  def init(_) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Blur.BotSupervisor},
      {DynamicSupervisor, strategy: :one_for_one, name: Blur.ResolverSupervisor}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
