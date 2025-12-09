defmodule AdventOfCode.Y2025.Day09 do
  @moduledoc """
  # Day 9: Movie Theater

  Problem Link: https://adventofcode.com/2025/day/9
  """
  use AdventOfCode.Helpers.InputReader, year: 2025, day: 9

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

  You
  <span title="wheeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee">slide
  down</span> the
  [firepole](https://en.wikipedia.org/wiki/Fireman%27s_pole) in the corner
  of the playground and land in the North Pole base movie theater!

  The movie theater has a big tile floor with an interesting pattern.
  Elves here are redecorating the theater by switching out some of the
  square tiles in the big grid they form. Some of the tiles are *red*; the
  Elves would like to find the largest rectangle that uses red tiles for
  two of its opposite corners. They even have a list of where the red
  tiles are located in the grid (your puzzle input).

  For example:

    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3

  Showing red tiles as `#` and other tiles as `.`, the above arrangement
  of red tiles would look like this:

    ..............
    .......#...#..
    ..............
    ..#....#......
    ..............
    ..#......#....
    ..............
    .........#.#..
    ..............

  You can choose any two red tiles as the opposite corners of your
  rectangle; your goal is to find the largest rectangle possible.

  For example, you could make a rectangle (shown as `O`) with an area of
  `24` between `2,5` and `9,7`:

    ..............
    .......#...#..
    ..............
    ..#....#......
    ..............
    ..OOOOOOOO....
    ..OOOOOOOO....
    ..OOOOOOOO.#..
    ..............

  Or, you could make a rectangle with area `35` between `7,1` and `11,7`:

    ..............
    .......OOOOO..
    .......OOOOO..
    ..#....OOOOO..
    .......OOOOO..
    ..#....OOOOO..
    .......OOOOO..
    .......OOOOO..
    ..............

  You could even make a thin rectangle with an area of only `6` between
  `7,3` and `2,3`:

    ..............
    .......#...#..
    ..............
    ..OOOOOO......
    ..............
    ..#......#....
    ..............
    .........#.#..
    ..............

  Ultimately, the largest rectangle you can make in this example has area
  *`50`*. One way to do this is between `2,5` and `11,1`:

    ..............
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..............
    .........#.#..
    ..............

  Using two red tiles as opposite corners, *what is the largest area of
  any rectangle you can make?*

  """
  def solve_1(data) do
    tiles =
      data
      |> Enum.map(fn line -> line |> String.split(",") |> Enum.map(&String.to_integer/1) end)

    for {[x0, y0] = _p1, index1} <- Enum.with_index(tiles),
        {[x1, y1] = _p2, index2} <- Enum.with_index(tiles),
        index2 > index1 do
      (abs(x1 - x0) + 1) * (abs(y1 - y0) + 1)
    end
    |> Enum.max()
  end

  @doc """
  # Part 2

  PROBLEM_TEXT_PART2
  """
  def solve_2(data) do
    {:error, data}
  end

  # --- </Solution Functions> ---
end
