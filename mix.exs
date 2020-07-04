defmodule Blur.Mixfile do
  use Mix.Project

  @version "0.2.1"

  def project do
    [
      app: :blur,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
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
      {:httpoison, "~> 1.6"},
      {:logger_file_backend, "~> 0.0.11"},
      {:excoveralls, "~> 0.13", only: :test},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rockerboo/blur"}
    ]
  end
end
