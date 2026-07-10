# GitHub Issues CLI

**ZeroCourse — Elixir & Phoenix, Course 2: Elixir Language Mastery**

A command-line tool that takes a repo name, pulls its issues, filters and
sorts them through a pipeline of small pure functions, and prints an
aligned text report. It is the Elixir equivalent of writing a small Ruby
gem — a Mix project with a clean module layout, an escript binary, and a
real test suite.

The through-line: **errors are values.** Every stage returns
`{:ok, result}` or `{:error, reason}`, and `run/2` threads them with
pattern matching. There is not a single `try/rescue` in a correct
solution.

## The design

| Module | Role | You implement it? |
|--------|------|-------------------|
| `IssuesCli.Fetcher` | Behaviour: where issues come from | No — provided |
| `IssuesCli.MockFetcher` | Reads canned API JSON from `priv/fixtures/` | No — provided |
| `IssuesCli.Pipeline` | `parse` → `filter_by_state` → `filter_by_label` → `sort_issues` → `take_issues` | **Yes** |
| `IssuesCli.Report` | Aligned text table | **Yes** |
| `IssuesCli` | `run/2` — the whole pipeline as one function | **Yes** |
| `IssuesCli.CLI` | escript entry point (OptionParser) | No — provided |

The fetcher is a behaviour so the source is swappable: the entire test
suite runs against `MockFetcher` — no network, no rate limits. This is
the same dependency-injection move as a Rails service object taking its
client as an argument, done the Elixir way.

## Getting started

```bash
mix deps.get
mix test
```

Everything except the three fetcher scaffolding tests fails at first —
each graded function raises `NotImplementedError` until you implement it.
Suggested order: `Pipeline.parse/1`, then the filters, sort, and take,
then `Report.format/1`, then wire them together in `IssuesCli.run/2`.

Try your work end to end:

```bash
mix escript.build
./issues_cli elixir-lang/elixir --state open --sort comments --count 5
```

## Tips

- `Pipeline` functions take the list first so they chain with `|>`.
  Keep them pure; no IO anywhere except the CLI module.
- `run/2` reads beautifully as a `with` expression: two fallible steps
  (fetch, parse), then a pure pipeline. Let `{:error, _}` fall through —
  `with` does that for free.
- The report's exact format is pinned by `test/report_test.exs` — read
  the moduledoc in `IssuesCli.Report` before writing code. Column width =
  the widest cell in that column, header included; last column unpadded.
- `String.pad_trailing/2`, `Enum.zip/2`, and `Enum.map_join/3` do most of
  the formatting work.
- The doctests are real tests — `mix test` runs them too.

## How this is graded

Push and CI runs the suite. Mentor review covers correctness, whether the
pipeline stays pure and tuple-threaded (no rescue, no raising on expected
errors), code quality, and the second half of the checkpoint: the short
write-up comparing this to how you'd build the same tool in Ruby — what
the pipeline operator and pattern matching changed about the design.
