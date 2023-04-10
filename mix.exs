defmodule Maxo.MixProject do
  use Mix.Project

  def project do
    [
      app: :maxo,
      version: "0.1.0",
      elixir: "~> 1.14",
      test_paths: ["test", "lib"],
      test_pattern: "*_test.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex, :crypto],
      mod: {Maxo.Application, []}
    ]
  end

  defp deps do
    [
      {:virtfs, "~> 0.1.4"},
      {:construct, github: "ExpressApp/construct"},
      {:test_iex, github: "mindreframer/test_iex", only: [:test]},
      {:mneme, "~> 0.3", only: [:test]},
      {:dialyxir, "~> 1.3", only: [:dev, :test]},
      {:benchee, "~> 1.1", only: [:test, :dev]}
    ]
  end
end
