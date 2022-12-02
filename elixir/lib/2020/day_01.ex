defmodule AdventOfCode.Y2020.Day01 do
  @moduledoc """
  --- Day 1: Report Repair ---
  Problem Link: https://adventofcode.com/2020/day/1
  """
  use AdventOfCode.Helpers.InputReader, year: 2020, day: 1

  def run_1(data \\ input!())

  def run_1(data) when is_binary(data), do: data |> parse() |> run_1()

  def run_1(data) when is_list(data), do: data |> solve1()

  def run_2(data \\ input!())

  def run_2(data) when is_binary(data), do: data |> parse() |> run_2()

  def run_2(data) when is_list(data), do: data |> solve2()

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # --- <Solution Functions> ---

  def solve1(data) do
    for x <- data, y <- Enum.drop(data, 1), x + y == 2020 do
      x * y
    end
    |> List.first()
  end

  def solve2(data) do
    for x <- data, y <- Enum.drop(data, 1), z <- Enum.drop(data, 2), x + y + z == 2020 do
      x * y * z
    end
    |> List.first()
  end

  # --- </Solution Functions> ---
end
