defmodule AdventOfCode.Y2025.Day04 do
  @moduledoc """
  # Day 4: Printing Department

  Problem Link: https://adventofcode.com/2025/day/4
  """
  use AdventOfCode.Helpers.InputReader, year: 2025, day: 4

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

  You ride the escalator down to the printing department. They're clearly
  getting ready for Christmas; they have lots of large rolls of paper
  everywhere, and there's even a massive printer in the corner (to handle
  the really <span title="This joke is stupid and I love it.">big</span>
  print jobs).

  Decorating here will be easy: they can make their own decorations. What
  you really need is a way to get further into the North Pole base while
  the elevators are offline.

  "Actually, maybe we can help with that," one of the Elves replies when
  you ask for help. "We're pretty sure there's a cafeteria on the other
  side of the back wall. If we could break through the wall, you'd be able
  to keep moving. It's too bad all of our forklifts are so busy moving
  those big rolls of paper around."

  If you can optimize the work the forklifts are doing, maybe they would
  have time to spare to break through the wall.

  The rolls of paper (`@`) are arranged on a large grid; the Elves even
  have a helpful diagram (your puzzle input) indicating where everything
  is located.

  For example:

    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.

  The forklifts can only access a roll of paper if there are *fewer than
  four rolls of paper* in the eight adjacent positions. If you can figure
  out which rolls of paper the forklifts can access, they'll spend less
  time looking and more time breaking down the wall to the cafeteria.

  In this example, there are *`13`* rolls of paper that can be accessed by
  a forklift (marked with `x`):

    ..xx.xx@x.
    x@@.@.@.@@
    @@@@@.x.@@
    @.@@@@..@.
    x@.@@@@.@x
    .@@@@@@@.@
    .@.@.@.@@@
    x.@@@.@@@@
    .@@@@@@@@.
    x.x.@@@.x.

  Consider your complete diagram of the paper roll locations. *How many
  rolls of paper can be accessed by a forklift?*

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

    for col <- 0..max_col,
        row <- 0..max_row,
        spot = Map.get(letter_map, {col, row}, "."),
        spot == "@",
        neighbor_map = get_neighbors(letter_map, col, row),
        4 > Enum.count(Map.values(neighbor_map), &(&1 == "@")),
        reduce: 0 do
      acc -> acc + 1
    end
  end

  @doc """
  # Part 2

  Now, the Elves just need help accessing as much of the paper as they
  can.

  Once a roll of paper can be accessed by a forklift, it can be removed. Once a
  roll of paper is removed, the forklifts might be able to access more rolls of
  paper, which they might also be able to remove. How many total rolls of paper
  could the Elves remove if they keep repeating this process?

  Starting with the same example as above, here is one way you could remove as
  many rolls of paper as possible, using highlighted @ to indicate that a roll
  of paper is about to be removed, and using x to indicate that a roll of paper
  was just removed:

  Initial state:
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.

  Remove 13 rolls of paper:
  ..xx.xx@x.
  x@@.@.@.@@
  @@@@@.x.@@
  @.@@@@..@.
  x@.@@@@.@x
  .@@@@@@@.@
  .@.@.@.@@@
  x.@@@.@@@@
  .@@@@@@@@.
  x.x.@@@.x.

  Remove 12 rolls of paper:
  .......x..
  .@@.x.x.@x
  x@@@@...@@
  x.@@@@..x.
  .@.@@@@.x.
  .x@@@@@@.x
  .x.@.@.@@@
  ..@@@.@@@@
  .x@@@@@@@.
  ....@@@...

  Remove 7 rolls of paper:
  ..........
  .x@.....x.
  .@@@@...xx
  ..@@@@....
  .x.@@@@...
  ..@@@@@@..
  ...@.@.@@x
  ..@@@.@@@@
  ..x@@@@@@.
  ....@@@...

  Remove 5 rolls of paper:
  ..........
  ..x.......
  .x@@@.....
  ..@@@@....
  ...@@@@...
  ..x@@@@@..
  ...@.@.@@.
  ..x@@.@@@x
  ...@@@@@@.
  ....@@@...

  Remove 2 rolls of paper:
  ..........
  ..........
  ..x@@.....
  ..@@@@....
  ...@@@@...
  ...@@@@@..
  ...@.@.@@.
  ...@@.@@@.
  ...@@@@@x.
  ....@@@...

  Remove 1 roll of paper:
  ..........
  ..........
  ...@@.....
  ..x@@@....
  ...@@@@...
  ...@@@@@..
  ...@.@.@@.
  ...@@.@@@.
  ...@@@@@..
  ....@@@...

  Remove 1 roll of paper:
  ..........
  ..........
  ...x@.....
  ...@@@....
  ...@@@@...
  ...@@@@@..
  ...@.@.@@.
  ...@@.@@@.
  ...@@@@@..
  ....@@@...

  Remove 1 roll of paper:
  ..........
  ..........
  ....x.....
  ...@@@....
  ...@@@@...
  ...@@@@@..
  ...@.@.@@.
  ...@@.@@@.
  ...@@@@@..
  ....@@@...

  Remove 1 roll of paper:
  ..........
  ..........
  ..........
  ...x@@....
  ...@@@@...
  ...@@@@@..
  ...@.@.@@.
  ...@@.@@@.
  ...@@@@@..
  ....@@@...

  Stop once no more rolls of paper are accessible by a forklift. In this
  example, a total of 43 rolls of paper can be removed.

  Start with your original diagram. How many rolls of paper in total can be
  removed by the Elves and their forklifts?
  """
  def solve_2(data) do
    {stockroom, max_col, max_row} =
      for {line, row} <- Enum.with_index(data),
          {letter, column} <-
            Enum.with_index(String.graphemes(line)),
          reduce: {%{}, 0, 0} do
        {stockroom, max_col, max_row} ->
          {Map.put(stockroom, {column, row}, letter), max(max_col, column), max(max_row, row)}
      end

    stockroom
    |> Stream.unfold(fn prev_stockroom ->
      case remove_rolls(prev_stockroom, max_col, max_row) do
        {_prev_stockroom, 0} ->
          nil

        {new_stockroom, removed_count} ->
          {{new_stockroom, removed_count}, new_stockroom}
      end
    end)
    # |> Stream.each(fn {stockroom, removed} ->
    #   IO.puts(removed)
    #   print(stockroom, max_col, max_row)
    # end)
    |> Enum.sum_by(fn {_stockroom, removed_count} -> removed_count end)
  end

  # --- </Solution Functions> ---

  defp get_neighbors(big_map, col, row) do
    for y <- -1..1, x <- -1..1, not (y == 0 and x == 0), into: %{} do
      {{y, x}, Map.get(big_map, {col + y, row + x}, ".")}
    end
  end

  defp remove_rolls(stockroom, max_col, max_row) do
    for col <- 0..max_col,
        row <- 0..max_row,
        spot = Map.get(stockroom, {col, row}),
        spot == "@",
        neighbor_map = get_neighbors(stockroom, col, row),
        4 > Enum.count(Map.values(neighbor_map), &(&1 == "@")),
        reduce: {stockroom, 0} do
      {stockroom, count} -> {Map.delete(stockroom, {col, row}), count + 1}
    end
  end

  # defp print(stockroom, cols, rows) do
  #   for y <- 0..rows do
  #     for x <- 0..cols do
  #       IO.write(Map.get(stockroom, {x, y}, "."))
  #     end
  #
  #     IO.write("\n")
  #   end
  #
  #   :ok
  # end
end
