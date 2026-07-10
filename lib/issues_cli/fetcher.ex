defmodule IssuesCli.Fetcher do
  @moduledoc """
  The contract every issue source implements.

  A fetcher takes a repo name like `"elixir-lang/elixir"` and returns the
  raw JSON body as a string — or a tagged error. Parsing is NOT the
  fetcher's job; that belongs to the pipeline (`IssuesCli.Pipeline.parse/1`).

  This is a behaviour so tests (and you, in IEx) can swap the source:
  the bundled `IssuesCli.MockFetcher` reads canned API responses from
  `priv/fixtures/` and the whole test suite runs against it — no network,
  no rate limits, no flakiness. If you later write a real HTTP fetcher,
  nothing else changes. This is the same dependency-injection move as a
  Rails service object taking a client in its constructor.

  You never need to edit this file.
  """

  @callback fetch(repo :: String.t()) :: {:ok, String.t()} | {:error, term()}
end
