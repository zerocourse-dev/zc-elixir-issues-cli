defmodule PipelineTest do
  use ExUnit.Case, async: true

  alias IssuesCli.Pipeline

  doctest IssuesCli.Pipeline

  @issues [
    %{
      "number" => 1,
      "state" => "open",
      "labels" => [%{"name" => "bug"}],
      "created_at" => "2026-03-01T00:00:00Z",
      "comments" => 5
    },
    %{
      "number" => 2,
      "state" => "closed",
      "labels" => [%{"name" => "bug"}, %{"name" => "docs"}],
      "created_at" => "2026-05-01T00:00:00Z",
      "comments" => 2
    },
    %{
      "number" => 3,
      "state" => "open",
      "labels" => [],
      "created_at" => "2026-04-01T00:00:00Z",
      "comments" => 9
    }
  ]

  describe "parse/1" do
    test "decodes a JSON array of issues" do
      assert {:ok, issues} = Pipeline.parse(~s([{"number": 7, "state": "open"}]))
      assert issues == [%{"number" => 7, "state" => "open"}]
    end

    test "decodes the empty array" do
      assert Pipeline.parse("[]") == {:ok, []}
    end

    test "returns {:error, {:malformed_json, _}} for garbage" do
      assert {:error, {:malformed_json, _reason}} = Pipeline.parse("{ nope")
    end

    test "returns {:error, :not_a_list} for a JSON object" do
      assert Pipeline.parse(~s({"message": "hi"})) == {:error, :not_a_list}
    end
  end

  describe "filter_by_state/2" do
    test "keeps only matching state" do
      assert Pipeline.filter_by_state(@issues, "open") |> numbers() == [1, 3]
      assert Pipeline.filter_by_state(@issues, "closed") |> numbers() == [2]
    end

    test ":all keeps everything" do
      assert Pipeline.filter_by_state(@issues, :all) |> numbers() == [1, 2, 3]
    end

    test "returns [] when nothing matches" do
      assert Pipeline.filter_by_state([List.first(@issues)], "closed") == []
    end
  end

  describe "filter_by_label/2" do
    test "keeps issues carrying the label" do
      assert Pipeline.filter_by_label(@issues, "bug") |> numbers() == [1, 2]
      assert Pipeline.filter_by_label(@issues, "docs") |> numbers() == [2]
    end

    test "nil keeps everything" do
      assert Pipeline.filter_by_label(@issues, nil) |> numbers() == [1, 2, 3]
    end

    test "an issue with no labels never matches" do
      assert Pipeline.filter_by_label(@issues, "enhancement") == []
    end
  end

  describe "sort_issues/2" do
    test ":created_at puts the newest first" do
      assert Pipeline.sort_issues(@issues, :created_at) |> numbers() == [2, 3, 1]
    end

    test ":comments puts the busiest first" do
      assert Pipeline.sort_issues(@issues, :comments) |> numbers() == [3, 1, 2]
    end

    test "sorting the empty list is fine" do
      assert Pipeline.sort_issues([], :created_at) == []
    end
  end

  describe "take_issues/2" do
    test "takes the first n" do
      assert Pipeline.take_issues(@issues, 2) |> numbers() == [1, 2]
    end

    test ":all takes everything" do
      assert Pipeline.take_issues(@issues, :all) |> numbers() == [1, 2, 3]
    end

    test "taking more than the list has returns the whole list" do
      assert Pipeline.take_issues(@issues, 50) |> numbers() == [1, 2, 3]
    end
  end

  defp numbers(issues), do: Enum.map(issues, & &1["number"])
end
