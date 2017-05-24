defmodule Bamboo.SparkPostAdapter.Mixfile do
  use Mix.Project

  @project_url "https://github.com/sparkpost/bamboo_sparkpost"
  @version "0.5.1"

  def project do
    [app: :bamboo_sparkpost,
     version: @version,
     elixir: "~> 1.4",
     source_url: @project_url,
     homepage_url: @project_url,
     name: "Bamboo SparkPost Adapter",
     description: "A Bamboo adapter for the SparkPost email service",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps(),
     docs: fn ->
       [
        source_ref: "v#{@version}",
        canonical: "http://hexdocs.pm/bamboo_sparkpost",
        main: "Bamboo Sparkpost Adapter",
        source_url: @project_url,
        extras: ["README.md", "CHANGELOG.md"]
       ]
     end,
    ]
  end

  def application do
    [applications: [:logger, :bamboo, :sparkpost]]
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
      {:bamboo, github: "thoughtbot/bamboo", branch: "master"},
      {:sparkpost, "~> 0.5.1"},
      {:ex_doc, "~> 0.9", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:cowboy, "~> 1.0", only: [:test, :dev]},
    ]
  end
end
