defmodule IssuesCliTest do
  use ExUnit.Case, async: true

  doctest IssuesCli

  describe "run/2 — happy path" do
    test "returns a formatted report for a known repo" do
      assert {:ok, report} = IssuesCli.run("elixir-lang/elixir")
      assert report =~ "TITLE"
      assert report =~ "4021"
    end

    test "defaults to newest-first over all states" do
      {:ok, report} = IssuesCli.run("elixir-lang/elixir")
      lines = String.split(report, "\n")
      # newest issue in the fixture is #4021, oldest is #3958
      assert Enum.at(lines, 1) =~ "4021"
      assert List.last(lines) =~ "3958"
      # closed issues included by default
      assert report =~ "4007"
    end

    test "filters by state" do
      {:ok, report} = IssuesCli.run("elixir-lang/elixir", state: "closed")
      assert report =~ "4007"
      refute report =~ "4021"
    end

    test "filters by label" do
      {:ok, report} = IssuesCli.run("elixir-lang/elixir", label: "docs")
      assert report =~ "4018"
      assert report =~ "3971"
      refute report =~ "4021"
    end

    test "sorts by comments" do
      {:ok, report} = IssuesCli.run("elixir-lang/elixir", sort: :comments)
      lines = String.split(report, "\n")
      # busiest issue in the fixture is #3999 with 41 comments
      assert Enum.at(lines, 1) =~ "3999"
    end

    test "takes only count issues" do
      {:ok, report} = IssuesCli.run("elixir-lang/elixir", count: 2)
      # header + 2 rows
      assert report |> String.split("\n") |> length() == 3
    end

    test "combines state, label, sort and count" do
      {:ok, report} =
        IssuesCli.run("elixir-lang/elixir",
          state: "open",
          label: "enhancement",
          sort: :comments,
          count: 1
        )

      lines = String.split(report, "\n")
      assert length(lines) == 2
      assert Enum.at(lines, 1) =~ "3999"
    end

    test "a repo with no issues reports the empty message" do
      assert {:ok, "No issues found."} = IssuesCli.run("quiet-org/quiet")
    end
  end

  describe "run/2 — errors are tagged tuples, never raises" do
    test "unknown repo flows the fetcher error through" do
      assert IssuesCli.run("nobody/nothing") == {:error, {:not_found, "nobody/nothing"}}
    end

    test "malformed JSON flows the parser error through" do
      assert {:error, {:malformed_json, _}} = IssuesCli.run("broken-org/broken")
    end

    test "a JSON body that is not a list flows through" do
      assert {:error, :not_a_list} = IssuesCli.run("odd-org/odd")
    end
  end

  describe "run/2 — dependency injection" do
    defmodule EmptyFetcher do
      @behaviour IssuesCli.Fetcher
      @impl true
      def fetch(_repo), do: {:ok, "[]"}
    end

    defmodule AngryFetcher do
      @behaviour IssuesCli.Fetcher
      @impl true
      def fetch(_repo), do: {:error, :rate_limited}
    end

    test "uses the fetcher passed in opts" do
      assert {:ok, "No issues found."} = IssuesCli.run("any/repo", fetcher: EmptyFetcher)
    end

    test "propagates custom fetcher errors" do
      assert IssuesCli.run("any/repo", fetcher: AngryFetcher) == {:error, :rate_limited}
    end
  end
end
