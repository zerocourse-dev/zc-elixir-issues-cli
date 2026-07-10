defmodule FetcherTest do
  use ExUnit.Case, async: true

  # These test the provided scaffolding — they pass from the start and
  # must stay passing.

  describe "MockFetcher.fetch/1" do
    test "returns {:ok, json_string} for a known repo" do
      assert {:ok, body} = IssuesCli.MockFetcher.fetch("elixir-lang/elixir")
      assert is_binary(body)
      assert body =~ "4021"
    end

    test "returns {:error, {:not_found, repo}} for an unknown repo" do
      assert IssuesCli.MockFetcher.fetch("nobody/nothing") ==
               {:error, {:not_found, "nobody/nothing"}}
    end

    test "implements the IssuesCli.Fetcher behaviour" do
      behaviours =
        IssuesCli.MockFetcher.module_info(:attributes)
        |> Keyword.get_values(:behaviour)
        |> List.flatten()

      assert IssuesCli.Fetcher in behaviours
    end
  end
end
