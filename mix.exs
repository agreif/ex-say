defmodule Say.MixProject do
  use Mix.Project

  @version "0.2.1"
  @source_url "https://github.com/agreif/ex-say"

  def project do
    [
      app: :say,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Text-to-Speech module for Elixir. It exposes a function Say.say/1 that advises the underlying OS or through a SSH tunnel to say the given text.",
      source_url: @source_url,
      package: [
        licenses: ["MIT"],
        links: %{
          "GitHub" => @source_url
        }
      ],
      docs: [
        main: "Say",
        source_url: @source_url,
        source_ref: "v#{@version}",
        extras: ["CHANGELOG.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
