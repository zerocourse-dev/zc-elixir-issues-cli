defmodule IssuesCli.Report do
  @moduledoc """
  Render a list of issue maps as an aligned text table.

  The exact shape (the tests pin this down):

      #    | STATE  | COMMENTS | TITLE
      4021 | open   | 12       | Compiler warning on ...
      17   | closed | 3        | Docs typo

  Rules:

    * Four columns: `#` (the issue `"number"`), `STATE`, `COMMENTS`, `TITLE`.
    * Columns are separated by `" | "`.
    * Every cell in a column is left-padded with spaces (`String.pad_trailing/2`)
      to the width of the column's widest cell — header included. The last
      column is NOT padded (no trailing whitespace).
    * Rows keep the order of the input list.
    * An empty list renders as exactly `"No issues found."`
  """

  @doc """
  Format issues as the aligned table described in the moduledoc.

      iex> IssuesCli.Report.format([])
      "No issues found."
  """
  def format(_issues) do
    raise "NotImplementedError: implement format/1"
  end
end
