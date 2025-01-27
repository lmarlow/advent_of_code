defmodule AdventOfCode.Y2022.Day03 do
  @moduledoc """
  # Day 3: Rucksack Reorganization

  Problem Link: https://adventofcode.com/2022/day/3
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 3

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
    |> Enum.map(&String.to_charlist/1)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  One Elf has the important job of loading all of the
  <a href="https://en.wikipedia.org/wiki/Rucksack"
  target="_blank">rucksacks</a> with supplies for the <span
  title="Where there's jungle, there's hijinxs.">jungle</span> journey.
  Unfortunately, that Elf didn't quite follow the packing instructions,
  and so a few items now need to be rearranged.

  Each rucksack has two large *compartments*. All items of a given type
  are meant to go into exactly one of the two compartments. The Elf that
  did the packing failed to follow this rule for exactly one item type per
  rucksack.

  The Elves have made a list of all of the items currently in each
  rucksack (your puzzle input), but they need your help finding the
  errors. Every item type is identified by a single lowercase or uppercase
  letter (that is, `a` and `A` refer to different types of items).

  The list of items for each rucksack is given as characters all on a
  single line. A given rucksack always has the same number of items in
  each of its two compartments, so the first half of the characters
  represent items in the first compartment, while the second half of the
  characters represent items in the second compartment.

  For example, suppose you have the following list of contents from six
  rucksacks:

      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw

  - The first rucksack contains the items `vJrwpWtwJgWrhcsFMMfFFhFp`,
    which means its first compartment contains the items `vJrwpWtwJgWr`,
    while the second compartment contains the items `hcsFMMfFFhFp`. The
    only item type that appears in both compartments is lowercase *`p`*.
  - The second rucksack's compartments contain `jqHRNqRjqzjGDLGL` and
    `rsFMfFZSrLrFZsSL`. The only item type that appears in both
    compartments is uppercase *`L`*.
  - The third rucksack's compartments contain `PmmdzqPrV` and `vPwwTWBwg`;
    the only common item type is uppercase *`P`*.
  - The fourth rucksack's compartments only share item type *`v`*.
  - The fifth rucksack's compartments only share item type *`t`*.
  - The sixth rucksack's compartments only share item type *`s`*.

  To help prioritize item rearrangement, every item type can be converted
  to a *priority*:

  - Lowercase item types `a` through `z` have priorities 1 through 26.
  - Uppercase item types `A` through `Z` have priorities 27 through 52.

  In the above example, the priority of the item type that appears in both
  compartments of each rucksack is 16 (`p`), 38 (`L`), 42 (`P`), 22 (`v`),
  20 (`t`), and 19 (`s`); the sum of these is *`157`*.

  Find the item type that appears in both compartments of each rucksack.
  *What is the sum of the priorities of those item types?*

  """
  def solve_1(data) do
    data
    |> Enum.map(&(&1 |> Enum.split(div(length(&1), 2)) |> Tuple.to_list()))
    |> priority_sums()
  end

  @doc """
  # Part 2
  """
  def solve_2(data) do
    data
    |> Enum.chunk_every(3)
    |> priority_sums()
  end

  def value(c) when c in ?A..?Z, do: c - ?A + 27
  def value(c), do: c - ?a + 1

  def priority_sums(chunks) do
    for [comp1 | rest] <- chunks,
        dupe = Enum.find(comp1, fn c -> Enum.all?(rest, &(c in &1)) end),
        val = value(dupe),
        reduce: 0 do
      score ->
        score + val
    end
  end

  # --- </Solution Functions> ---
end
