defmodule AdventOfCode.Y2025.Day05 do
  @moduledoc """
  # Day 5: Cafeteria

  Problem Link: https://adventofcode.com/2025/day/5
  """
  use AdventOfCode.Helpers.InputReader, year: 2025, day: 5

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

  As the forklifts break through the wall, the Elves are delighted to
  discover that there was a cafeteria on the other side after all.

  You can hear a commotion coming from the kitchen. "At this rate, we
  won't have any time left to put the wreaths up in the dining hall!"
  Resolute in your quest, you investigate.

  "If only we hadn't switched to the new inventory management system right
  before Christmas!" another Elf exclaims. You ask what's going on.

  The Elves in the kitchen explain the situation: because of their
  complicated new inventory management system, they can't figure out which
  of their ingredients are *fresh* and which are
  <span title="No, this puzzle does not take place on Gleba. Why do you ask?">*spoiled*</span>.
  When you ask how it works, they give you a copy of their database (your
  puzzle input).

  The database operates on *ingredient IDs*. It consists of a list of
  *fresh ingredient ID ranges*, a blank line, and a list of *available
  ingredient IDs*. For example:

    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32

  The fresh ID ranges are *inclusive*: the range `3-5` means that
  ingredient IDs `3`, `4`, and `5` are all *fresh*. The ranges can also
  *overlap*; an ingredient ID is fresh if it is in *any* range.

  The Elves are trying to determine which of the *available ingredient
  IDs* are *fresh*. In this example, this is done as follows:

  - Ingredient ID `1` is spoiled because it does not fall into any range.
  - Ingredient ID `5` is *fresh* because it falls into range `3-5`.
  - Ingredient ID `8` is spoiled.
  - Ingredient ID `11` is *fresh* because it falls into range `10-14`.
  - Ingredient ID `17` is *fresh* because it falls into range `16-20` as
  well as range `12-18`.
  - Ingredient ID `32` is spoiled.

  So, in this example, *`3`* of the available ingredient IDs are fresh.

  Process the database file from the new inventory management system. *How
  many of the available ingredient IDs are fresh?*

  """
  def solve_1(data) do
    {fresh_ranges, ingredients} = Enum.split_while(data, &String.contains?(&1, "-"))

    fresh_ranges =
      fresh_ranges
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
      |> Enum.map(fn [first, last] -> first..last end)

    ingredients = ingredients |> Enum.map(&String.to_integer/1)

    ingredients |> Enum.count(fn n -> Enum.any?(fresh_ranges, &(n in &1)) end)
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
