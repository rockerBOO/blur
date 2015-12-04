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

  def application do
    [applications: [:logger, :exirc, :con_cache, :httpoison, :lastfm],
     mod: {Blur.IRC.App, [host: "irc.twitch.tv", port: 6667]}]
  end

  defp deps do
    [{:exirc, github: "bitwalker/exirc"},
     {:con_cache, "~> 0.9.0"},

     {:socket, "~> 0.3.1"},
     {:amnesia, "~> 0.2.0"},
     {:poison, "~> 1.5"},
     {:httpoison, "~> 0.7.2"},
     {:lastfm, github: "rockerBOO/lastfm"},
     {:dogma, "~> 0.0", only: :dev}]
  end
end
