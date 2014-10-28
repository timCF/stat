defmodule Stat.Mixfile do
  use Mix.Project

  def project do
    [app: :stat,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications:  [
                      :logger,

                      :hashex,
                      :tinca,
                      :exactor
                    ],
     mod: {Stat, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:hashex, github: "timCF/hashex"},
      {:tinca, github: "timCF/tinca"},
      {:exactor, github: "sasa1977/exactor"}
    ]
  end
end
