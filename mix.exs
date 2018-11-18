defmodule Bamboo.SparkPostAdapter.Mixfile do
  use Mix.Project

  @project_url "https://github.com/andrewtimberlake/bamboo_sparkpost"
  @version "1.1.1"

  def project do
    [
      app: :bamboo_sparkpost,
      version: @version,
      elixir: "~> 1.3",
      source_url: @project_url,
      homepage_url: @project_url,
      name: "Bamboo SparkPost Adapter",
      description: "A Bamboo adapter for the SparkPost email service",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: fn ->
        [
          source_ref: "v#{@version}",
          canonical: "http://hexdocs.pm/bamboo_sparkpost",
          main: "Bamboo.SparkPostAdapter",
          source_url: @project_url,
          extras: ["README.md", "CHANGELOG.md"]
        ]
      end
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

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:bamboo, github: "thoughtbot/bamboo", only: [:test, :dev]},
      {:ex_doc, "~> 0.9", only: :dev},
      {:earmark, ">= 0.0.0", only: :dev},
      {:plug_cowboy, "~> 1.0", only: [:test, :dev]},
      {:jason, "~> 1.1", only: [:test, :dev]}
    ]
  end
end
