defmodule IssuesCli.CLI do
  @moduledoc """
  The escript entry point. Thin on purpose: parse flags, call
  `IssuesCli.run/2`, print the result, exit non-zero on error.

  Build and try it:

      mix escript.build
      ./issues_cli elixir-lang/elixir --state open --sort comments --count 5

  You never need to edit this file — all the interesting work happens in
  the modules it calls.
  """

  def main(argv) do
    {opts, args, _invalid} =
      OptionParser.parse(argv,
        strict: [state: :string, label: :string, sort: :string, count: :integer],
        aliases: [s: :state, l: :label, n: :count]
      )

    case args do
      # apply/3 keeps the compiler from tracing into IssuesCli.run/2 while
      # it is still an unimplemented stub (its "always raises" type would
      # otherwise fail --warnings-as-errors on this call site).
      [repo] -> apply(IssuesCli, :run, [repo, normalize(opts)]) |> output()
      _ -> usage()
    end
  end

  defp normalize(opts) do
    opts
    |> Keyword.take([:state, :label, :sort, :count])
    |> Enum.map(fn
      {:sort, value} -> {:sort, String.to_existing_atom(value)}
      pair -> pair
    end)
  end

  defp output({:ok, report}) do
    IO.puts(report)
  end

  defp output({:error, reason}) do
    IO.puts(:stderr, "error: #{inspect(reason)}")
    System.halt(1)
  end

  defp usage do
    IO.puts(:stderr, """
    usage: issues_cli OWNER/REPO [--state open|closed] [--label NAME]
                      [--sort created_at|comments] [--count N]
    """)

    System.halt(64)
  end
end
