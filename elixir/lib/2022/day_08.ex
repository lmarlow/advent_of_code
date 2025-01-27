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

    columns = transpose(rows)

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

  Content with the amount of tree cover available, the Elves just need to
  know the best spot to build their tree house: they would like to be able
  to see a lot of *trees*.

  To measure the viewing distance from a given tree, look up, down, left,
  and right from that tree; stop if you reach an edge or at the first tree
  that is the same height or taller than the tree under consideration. (If
  a tree is right on the edge, at least one of its viewing distances will
  be zero.)

  The Elves don't care about distant trees taller than those found by the
  rules above; the proposed tree house has large
  <a href="https://en.wikipedia.org/wiki/Eaves" target="_blank">eaves</a>
  to keep it dry, so they wouldn't be able to see higher than the tree
  house anyway.

  In the example above, consider the middle `5` in the second row:

      30373
      25512
      65332
      33549
      35390

  - Looking up, its view is not blocked; it can see *`1`* tree (of height
    `3`).
  - Looking left, its view is blocked immediately; it can see only *`1`*
    tree (of height `5`, right next to it).
  - Looking right, its view is not blocked; it can see *`2`* trees.
  - Looking down, its view is blocked eventually; it can see *`2`* trees
    (one of height `3`, then the tree of height `5` that blocks its view).

  A tree's *scenic score* is found by *multiplying together* its viewing
  distance in each of the four directions. For this tree, this is *`4`*
  (found by multiplying `1 * 1 * 2 * 2`).

  However, you can do even better: consider the tree of height `5` in the
  middle of the fourth row:

      30373
      25512
      65332
      33549
      35390

  - Looking up, its view is blocked at *`2`* trees (by another tree with a
    height of `5`).
  - Looking left, its view is not blocked; it can see *`2`* trees.
  - Looking down, its view is also not blocked; it can see *`1`* tree.
  - Looking right, its view is blocked at *`2`* trees (by a massive tree
    of height `9`).

  This tree's scenic score is *`8`* (`2 * 2 * 1 * 2`); this is the ideal
  spot for the tree house.

  Consider each tree on your map. *What is the highest scenic score
  possible for any tree?*
  """
  def solve_2(data) do
    rows =
      data
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(fn row -> Enum.map(row, &(&1 - ?0)) end)

    columns = transpose(rows)

    max_index = length(rows) - 1

    for y <- 0..max_index,
        x <- 0..max_index,
        row = Enum.at(rows, y),
        column = Enum.at(columns, x),
        {west, [height | east]} = Enum.split(row, x),
        {north, [_h | south]} = Enum.split(column, y) do
      if 0 in [x, y] or max_index in [x, y] do
        0
      else
        view_distance(Enum.reverse(west), height) *
          view_distance(east, height) *
          view_distance(Enum.reverse(north), height) *
          view_distance(south, height)
      end
    end
    |> Enum.max()
  end

  def running_max([]), do: []
  def running_max([_ | _] = list), do: running_max(list, [0])

  def running_max([_], acc), do: Enum.reverse(acc)
  def running_max([h | rest], [m | _] = acc), do: running_max(rest, [max(h, m) | acc])

  def transpose(list), do: Enum.zip_with(list, & &1)

  def view_distance(list, height) do
    list
    |> Enum.reduce_while(0, fn x, acc ->
      if x >= height, do: {:halt, acc + 1}, else: {:cont, acc + 1}
    end)
  end

  # --- </Solution Functions> ---
end
