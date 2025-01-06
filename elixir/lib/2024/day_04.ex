defmodule AdventOfCode.Y2024.Day04 do
  @moduledoc """
  # Day 4: Ceres Search

  Problem Link: https://adventofcode.com/2024/day/4
  """
  use AdventOfCode.Helpers.InputReader, year: 2024, day: 4

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  "Looks like the Chief's not here. Next!" One of The Historians pulls out
  a device and pushes the only button on it. After a brief flash, you
  recognize the interior of the [Ceres monitoring station](/2019/day/10)!

  As the search for the Chief continues, a small Elf who lives on the
  station tugs on your shirt; she'd like to know if you could help her
  with her *word search* (your puzzle input). She only has to find one
  word: `XMAS`.

  This word search allows words to be horizontal, vertical, diagonal,
  written backwards, or even overlapping other words. It's a little
  unusual, though, as you don't merely need to find one instance of
  `XMAS` - you need to find *all of them*. Here are a few ways `XMAS`
  might appear, where irrelevant characters have been replaced with `.`:

    ..X...
    .SAMX.
    .A..A.
    XMAS.S
    .X....

  The actual word search will be full of letters instead. For example:

    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX

  In this word search, `XMAS` occurs a total of *`18`* times; here's the
  same word search again, but where letters not involved in any `XMAS`
  have been replaced with `.`:

    ....XXMAS.
    .SAMXMS...
    ...S..A...
    ..A.A.MS.X
    XMASAMX.MM
    X.....XA.A
    S.S.S.S.SS
    .A.A.A.A.A
    ..M.M.M.MM
    .X.X.XMASX

  Take a look at the little Elf's word search. *How many times does `XMAS`
  appear?*

  """
  def solve_1(data) do
    {letter_map, max_col, max_row} =
      for {line, row} <- Enum.with_index(data),
          {letter, column} <-
            Enum.with_index(String.graphemes(line)),
          reduce: {%{}, 0, 0} do
        {letter_map, max_col, max_row} ->
          {Map.put(letter_map, {column, row}, letter), max(max_col, column), max(max_row, row)}
      end

    deltas = [
      _we_deltas = [{1, 0}, {2, 0}, {3, 0}],
      _ew_deltas = [{-1, 0}, {-2, 0}, {-3, 0}],
      _ns_deltas = [{0, 1}, {0, 2}, {0, 3}],
      _sn_deltas = [{0, -1}, {0, -2}, {0, -3}],
      _se_deltas = [{1, 1}, {2, 2}, {3, 3}],
      _ne_deltas = [{1, -1}, {2, -2}, {3, -3}],
      _sw_deltas = [{-1, 1}, {-2, 2}, {-3, 3}],
      _nw_deltas = [{-1, -1}, {-2, -2}, {-3, -3}]
    ]

    for x <- 0..max_col,
        y <- 0..max_row,
        "X" == Map.get(letter_map, {x, y}),
        [{m_dx, m_dy}, {a_dx, a_dy}, {s_dx, s_dy}] <- deltas,
        m_xy = {x + m_dx, y + m_dy},
        a_xy = {x + a_dx, y + a_dy},
        s_xy = {x + s_dx, y + s_dy},
        match?(%{^m_xy => "M", ^a_xy => "A", ^s_xy => "S"}, letter_map),
        reduce: 0 do
      acc ->
        acc + 1
    end
  end

  @doc """
  # Part 2
  """
  def solve_2(_data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
end
