defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "0.20.22",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:eex, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "~> 1.2"},
      {:nx, github: "elixir-nx/nx", sparse: "nx"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:req, "~> 0.5"},
      {:floki, "~> 0.34.0"},
      {:jason, "~> 1.2"},
      {:pandex, "~> 0.2"}
    ]
  end
end
