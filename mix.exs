defmodule FileServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :file_server,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FileServer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.7"},
      {:httpoison, "~> 2.2"},
      {:jason, "~> 1.4"},
      {:image, "~> 0.54"}
    ]
  end
end
