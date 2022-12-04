defmodule AdventOfCode.Y2022.Day01 do
  @moduledoc """
  --- Day 1: Calorie Counting ---
  Problem Link: https://adventofcode.com/2022/day/1
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 1

  @doc ~S"""
  Sample data:

  ```
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n")
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    data
    |> elf_calories()
    |> Enum.max()
  end

  @doc """
  """
  def solve_2(data) do
    data
    |> elf_calories()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp elf_calories(data) do
    data
    |> Enum.reduce([0], fn
      "", snacks -> [0 | snacks]
      n, [snack | snacks] -> [snack + String.to_integer(n) | snacks]
    end)
  end

  # --- </Solution Functions> ---
end
