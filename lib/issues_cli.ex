defmodule IssuesCli do
  @moduledoc """
  Fetch → parse → filter → sort → take → format, as one function.

  `run/2` is where the pipeline becomes a program. It threads tagged
  tuples: any `{:error, _}` from the fetcher or the parser flows straight
  out untouched; only the happy path reaches the report. Reach for `with`
  — it reads like the pipeline it is:

      with {:ok, body} <- fetcher.fetch(repo),
           {:ok, issues} <- Pipeline.parse(body) do
        ...
      end

  Options (all optional):

    * `:fetcher` — a module implementing `IssuesCli.Fetcher`
      (default `IssuesCli.MockFetcher`)
    * `:state` — `"open"`, `"closed"`, or `:all` (default `:all`)
    * `:label` — a label name, or `nil` for no label filter (default `nil`)
    * `:sort` — `:created_at` or `:comments` (default `:created_at`)
    * `:count` — a positive integer, or `:all` (default `:all`)
  """

  alias IssuesCli.{MockFetcher, Pipeline, Report}

  # Silences the "unused alias" warning in the skeleton — delete this line
  # once your implementation uses the aliases.
  _ = {MockFetcher, Pipeline, Report}

  @doc """
  Run the whole pipeline for `repo` and return `{:ok, report_string}`
  or a tagged error from any stage.

      iex> {:ok, report} = IssuesCli.run("elixir-lang/elixir", count: 3)
      iex> is_binary(report)
      true
  """
  def run(_repo, _opts \\ []) do
    raise "NotImplementedError: implement run/2"
  end
end
