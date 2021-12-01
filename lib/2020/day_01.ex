defmodule AdventOfCode.Y2020.Day01 do
  @moduledoc """
  --- Day 1: Report Repair ---
  Problem Link: https://adventofcode.com/2020/day/1
  """
  use AdventOfCode.Helpers.InputReader, year: 2020, day: 1

  def run_1(data \\ input!())

  def run_1(data) when is_binary(data), do: data |> parse() |> run_1()

  def run_1(data) when is_list(data), do: data |> solve1()

  def run_2, do: {:not_implemented, 2}

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
    |> IO.inspect()
    |> List.first()
  end

  # --- </Solution Functions> ---
end
