defmodule AdventOfCode.Y2022.Day08 do
  @moduledoc """
  # Day 8: Treetop Tree House

  Problem Link: https://adventofcode.com/2022/day/8
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 8

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

  The expedition comes across a peculiar patch of tall trees all planted
  carefully in a grid. The Elves explain that a previous expedition
  planted these trees as a reforestation effort. Now, they're curious if
  this would be a good location for a
  <a href="https://en.wikipedia.org/wiki/Tree_house" target="_blank">tree
  house</a>.

  First, determine whether there is enough tree cover here to keep a tree
  house *hidden*. To do this, you need to count the number of trees that
  are *visible from outside the grid* when looking directly along a row or
  column.

  The Elves have already launched a
  <a href="https://en.wikipedia.org/wiki/Quadcopter"
  target="_blank">quadcopter</a> to generate a map with the height of each
  tree (<span
  title="The Elves have already launched a quadcopter (your puzzle input).">your
  puzzle input</span>). For example:

      30373
      25512
      65332
      33549
      35390

  Each tree is represented as a single digit whose value is its height,
  where `0` is the shortest and `9` is the tallest.

  A tree is *visible* if all of the other trees between it and an edge of
  the grid are *shorter* than it. Only consider trees in the same row or
  column; that is, only look up, down, left, or right from any given tree.

  All of the trees around the edge of the grid are *visible* - since they
  are already on the edge, there are no trees to block the view. In this
  example, that only leaves the *interior nine trees* to consider:

  - The top-left `5` is *visible* from the left and top. (It isn't visible
    from the right or bottom since other trees of height `5` are in the
    way.)
  - The top-middle `5` is *visible* from the top and right.
  - The top-right `1` is not visible from any direction; for it to be
    visible, there would need to only be trees of height *0* between it
    and an edge.
  - The left-middle `5` is *visible*, but only from the right.
  - The center `3` is not visible from any direction; for it to be
    visible, there would need to be only trees of at most height `2`
    between it and an edge.
  - The right-middle `3` is *visible* from the right.
  - In the bottom row, the middle `5` is *visible*, but the `3` and `4`
    are not.

  With 16 trees visible on the edge and another 5 visible in the interior,
  a total of *`21`* trees are visible in this arrangement.

  Consider your map; *how many trees are visible from outside the grid?*

  """
  def solve_1(data) do
    rows =
      data
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(fn row -> Enum.map(row, &(&1 - ?0)) end)

    columns = Enum.zip_with(rows, & &1)

    running_max_rows = Enum.map(rows, &running_max/1)
    running_max_reverse_rows = Enum.map(rows, &Enum.reverse(running_max(Enum.reverse(&1))))
    running_max_columns = transpose(Enum.map(columns, &running_max/1))

    running_max_reverse_columns =
      transpose(Enum.map(columns, &Enum.reverse(running_max(Enum.reverse(&1)))))

    max_index = length(rows) - 1

    for {row, y} <- Enum.with_index(rows),
        {height, x} <- Enum.with_index(row),
        sightlines =
          Enum.map(
            [
              running_max_rows,
              running_max_columns,
              running_max_reverse_rows,
              running_max_reverse_columns
            ],
            fn matrix -> Enum.at(Enum.at(matrix, y), x) end
          ),
        min_sightline = Enum.min(sightlines),
        x == 0 or y == 0 or x == max_index or y == max_index or height > min_sightline,
        true do
      {x, y}
    end
    |> length()
  end

  @doc """
  # Part 2
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  def running_max([]), do: []
  def running_max([_ | _] = list), do: running_max(list, [0])

  def running_max([_], acc), do: Enum.reverse(acc)
  def running_max([h | rest], [m | _] = acc), do: running_max(rest, [max(h, m) | acc])

  def transpose(list), do: Enum.zip_with(list, & &1)
  # --- </Solution Functions> ---
end
