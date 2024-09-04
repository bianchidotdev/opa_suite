defmodule OPA.MixProject do
  use Mix.Project

  @version "0.0.1"
  @source_url "https://github.com/bianchidotdev/opa_suite"

  def project do
    [
      app: :opa,
      version: @version,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      name: "opa_suite",
      description: "OPA (Open Policy Agent) integration for Elixir",
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.14", optional: true},
      {:req, "~> 0.5.0", optional: true},

      # dev/test/docs
      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end

  def docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      extras: [
        "README.md"
      ]
    ]
  end
end
