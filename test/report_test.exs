defmodule ReportTest do
  use ExUnit.Case, async: true

  alias IssuesCli.Report

  doctest IssuesCli.Report

  @issues [
    %{"number" => 4021, "state" => "open", "comments" => 12, "title" => "Compiler warning"},
    %{"number" => 17, "state" => "closed", "comments" => 3, "title" => "Docs typo"}
  ]

  test "renders the exact aligned table" do
    expected =
      """
      #    | STATE  | COMMENTS | TITLE
      4021 | open   | 12       | Compiler warning
      17   | closed | 3        | Docs typo
      """
      |> String.trim_trailing("\n")

    assert Report.format(@issues) == expected
  end

  test "starts with the header row" do
    assert Report.format(@issues) |> String.starts_with?("#")
    assert Report.format(@issues) =~ "STATE"
    assert Report.format(@issues) =~ "COMMENTS"
    assert Report.format(@issues) =~ "TITLE"
  end

  test "column width grows with the widest cell" do
    issues = [
      %{"number" => 1, "state" => "open", "comments" => 1_000_000, "title" => "t"}
    ]

    report = Report.format(issues)
    # The COMMENTS header pads to the width of "1000000" (7 chars) < "COMMENTS" (8)
    # so here the value pads to the header width instead.
    assert report =~ "COMMENTS | TITLE"
    assert report =~ "1000000  | t"
  end

  test "keeps input order" do
    report = Report.format(@issues)
    assert :binary.match(report, "4021") < :binary.match(report, "17 ")
  end

  test "no trailing whitespace on any line" do
    Report.format(@issues)
    |> String.split("\n")
    |> Enum.each(fn line ->
      assert line == String.trim_trailing(line)
    end)
  end

  test "the empty list renders the empty message" do
    assert Report.format([]) == "No issues found."
  end
end
