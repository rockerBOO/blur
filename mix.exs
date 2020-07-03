defmodule Blur.Mixfile do
  use Mix.Project

  def project do
    [
      app: :blur,
      version: "0.2.1-beta2",
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
    [
      applications: [:logger, :exirc, :con_cache, :httpoison]
    ]
  end

  defp deps do
    [
      {:exirc, "~> 1.1"},
      {:con_cache, "~> 0.13"},
      {:amnesia, "~> 0.2.0"},
      {:poison, "~> 1.5"},
      {:httpoison, "~> 0.7.2"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:logger_file_backend, "~> 0.0.11"},
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
