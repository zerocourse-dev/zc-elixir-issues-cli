defmodule IssuesCli.MockFetcher do
  @moduledoc """
  A fetcher that reads canned GitHub API responses from `priv/fixtures/`.

  `"elixir-lang/elixir"` maps to `priv/fixtures/elixir-lang-elixir.json`.
  Unknown repos return `{:error, {:not_found, repo}}` — exactly the shape
  a real HTTP fetcher would return for a 404.

  You never need to edit this file.
  """

  @behaviour IssuesCli.Fetcher

  @impl true
  def fetch(repo) when is_binary(repo) do
    file = String.replace(repo, "/", "-") <> ".json"
    path = Path.join(fixtures_dir(), file)

    case File.read(path) do
      {:ok, contents} -> {:ok, contents}
      {:error, :enoent} -> {:error, {:not_found, repo}}
      {:error, reason} -> {:error, reason}
    end
  end

  defp fixtures_dir do
    Path.join(:code.priv_dir(:issues_cli), "fixtures")
  end
end
