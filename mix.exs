defmodule Blur.Mixfile do
  use Mix.Project

  def project do
    [app: :blur,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :exirc, :con_cache, :httpoison],
     mod: {Blur.IRC.App, [host: "irc.twitch.tv", port: 6667]}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:exirc, github: "bitwalker/exirc"},
     {:con_cache, "~> 0.8.0"},
     {:socket, "~> 0.3.0"},
     {:amnesia, github: "meh/amnesia"},
     {:poison, "~> 1.5"},
     {:httpoison, "~> 0.7.2"}]
  end
end
