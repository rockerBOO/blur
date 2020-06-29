defmodule Blur.Mixfile do
  use Mix.Project

  def project do
    [
      app: :blur,
      version: "0.2.1-beta1",
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Blur",
      source_url: "https://github.com/rockerboo/blur",
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  defp description do
    "Twitch Chat Bot"
  end

  def application do
    [applications: [:logger, :exirc, :con_cache, :httpoison], mod: {Blur.IRC.App, []}]
  end

  defp deps do
    [
      {:exirc, "~> 1.1"},
      {:con_cache, "~> 0.9.0"},
      {:amnesia, "~> 0.2.0"},
      {:poison, "~> 1.5"},
      {:httpoison, "~> 0.7.2"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rockerboo/blur"}
    ]
  end
end
