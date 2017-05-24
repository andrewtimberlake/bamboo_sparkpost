defmodule Bamboo.SparkPostAdapter.Mixfile do
  use Mix.Project

  @project_url "https://github.com/andrewtimberlake/bamboo_sparkpost"
  @version "0.5.1"

  def project do
    [app: :bamboo_sparkpost,
     version: @version,
     elixir: "~> 1.2",
     source_url: @project_url,
     homepage_url: @project_url,
     name: "Bamboo SparkPost Adapter",
     description: "A Bamboo adapter for the SparkPost email service",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps,
     docs: fn ->
       [source_ref: "v#{@version}",
        canonical: "http://hexdocs.pm/bamboo_sparkpost",
        main: "Bamboo Sparkpost Adapter",
        source_url: @project_url,
        extras: ["README.md", "CHANGELOG.md"]
       ]
     end,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :bamboo]]
  end

  defp package do
    [
      maintainers: ["Andrew Timberlake"],
      licenses: ["MIT"],
      links: %{"Github" => @project_url}
    ]
  end

  defp deps do
    [
      {:bamboo, "~> 0.8"},
      {:cowboy, "~> 1.0", only: [:test, :dev]},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.9", only: :dev},
      {:excoveralls, "~> 0.5.7", only: :test},
      {:httpoison, "~> 0.11.2"},
    ]
  end
end
