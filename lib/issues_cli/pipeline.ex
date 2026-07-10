defmodule IssuesCli.Pipeline do
  @moduledoc """
  The data pipeline: raw JSON string in, a clean list of issue maps out,
  then filter → sort → take, each as a small pure function.

  Every function here is built to sit in a `|>` chain, and every failure
  is a tagged tuple — no exceptions for expected problems. That is the
  Elixir idiom this course installs: errors are values you pattern-match,
  not control flow you rescue.

  Issue maps keep the GitHub API's string keys. The ones you care about:

      %{
        "number" => 4021,
        "title" => "Compiler warning on ...",
        "state" => "open",
        "labels" => [%{"name" => "bug"}, ...],
        "created_at" => "2026-05-14T09:30:00Z",
        "comments" => 12,
        "user" => %{"login" => "someone"}
      }
  """

  @doc """
  Decode a raw JSON body into a list of issue maps.

  Returns `{:ok, issues}` for a JSON array, `{:error, {:malformed_json, reason}}`
  when the body does not parse (pass Jason's error struct through as
  `reason`), and `{:error, :not_a_list}` when it parses to anything that
  is not a list.

      iex> IssuesCli.Pipeline.parse(~s([{"number": 1}]))
      {:ok, [%{"number" => 1}]}
      iex> IssuesCli.Pipeline.parse("{ not json") |> elem(0)
      :error
  """
  def parse(_json) do
    raise "NotImplementedError: implement parse/1"
  end

  @doc """
  Keep issues whose `"state"` equals `state` ("open" or "closed").
  Passing `:all` keeps everything.

      iex> IssuesCli.Pipeline.filter_by_state([%{"state" => "open"}, %{"state" => "closed"}], "open")
      [%{"state" => "open"}]
  """
  def filter_by_state(_issues, _state) do
    raise "NotImplementedError: implement filter_by_state/2"
  end

  @doc """
  Keep issues carrying a label with `"name"` equal to `label`.
  Passing `nil` keeps everything.

      iex> IssuesCli.Pipeline.filter_by_label([%{"labels" => [%{"name" => "bug"}]}], "docs")
      []
  """
  def filter_by_label(_issues, _label) do
    raise "NotImplementedError: implement filter_by_label/2"
  end

  @doc """
  Sort issues, newest or busiest first:

    * `:created_at` — most recent `"created_at"` first
    * `:comments` — highest `"comments"` count first
  """
  def sort_issues(_issues, _field) do
    raise "NotImplementedError: implement sort_issues/2"
  end

  @doc """
  Take the first `count` issues; `:all` takes everything.

      iex> IssuesCli.Pipeline.take_issues([1, 2, 3], 2)
      [1, 2]
  """
  def take_issues(_issues, _count) do
    raise "NotImplementedError: implement take_issues/2"
  end
end
