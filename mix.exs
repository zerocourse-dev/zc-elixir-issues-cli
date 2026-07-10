defmodule IssuesCli.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues_cli,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: IssuesCli.CLI]
  end

  defp deps do
    [
      {:jason, "~> 1.4"}
    ]
  end
end
