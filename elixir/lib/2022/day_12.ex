defmodule AdventOfCode.Y2022.Day12 do
  @moduledoc """
  # Day 12: Hill Climbing Algorithm

  Problem Link: https://adventofcode.com/2022/day/12
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 12

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

  You try contacting the Elves using your <span
title="When you look up the specs for your handheld device, every field just says &quot;plot&quot;.">handheld
device</span>, but the river you're following must be too low to get a
decent signal.

You ask the device for a heightmap of the surrounding area (your puzzle
input). The heightmap shows the local area from above broken into a
grid; the elevation of each square of the grid is given by a single
lowercase letter, where `a` is the lowest elevation, `b` is the
next-lowest, and so on up to the highest elevation, `z`.

Also included on the heightmap are marks for your current position (`S`)
and the location that should get the best signal (`E`). Your current
position (`S`) has elevation `a`, and the location that should get the
best signal (`E`) has elevation `z`.

You'd like to reach `E`, but to save energy, you should do it in *as few
steps as possible*. During each step, you can move exactly one square
up, down, left, or right. To avoid needing to get out your climbing
gear, the elevation of the destination square can be *at most one
higher* than the elevation of your current square; that is, if your
current elevation is `m`, you could step to elevation `n`, but not to
elevation `o`. (This also means that the elevation of the destination
square can be much lower than the elevation of your current square.)

For example:

    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi

Here, you start in the top-left corner; your goal is near the middle.
You could start by moving down or right, but eventually you'll need to
head toward the `e` at the bottom. From there, you can spiral around to
the goal:

    v..v<<<<
    >v.vv<<^
    .>vv>E^^
    ..v>>>^^
    ..>>>>>^

In the above diagram, the symbols indicate whether the path exits each
square moving up (`^`), down (`v`), left (`<`), or right (`>`). The
location that should get the best signal is still `E`, and `.` marks
unvisited squares.

This path reaches the goal in *`31`* steps, the fewest possible.

*What is the fewest steps required to move from your current position to
the location that should get the best signal?*

  """
  def solve_1(data) do
    {1, :not_implemented}
  end

  @doc """
  # Part 2
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
end
