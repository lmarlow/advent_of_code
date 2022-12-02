defmodule AdventOfCode.Y2021.Day06 do
  @moduledoc """
  --- Day 6: Lanternfish ---
  Problem Link: https://adventofcode.com/2021/day/6
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 6

  @doc ~S"""
  Sample data:

  ```
  3,4,3,1,2
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, ",", trim: true))
    |> Enum.map(&String.to_integer/1)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    data
    |> population(80)
  end

  @doc """
  """
  def solve_2(data) do
    data
    |> population(256)
  end

  # --- </Solution Functions> ---

  def population(data, day) do
    data
    |> population_stream()
    |> Enum.at(day)
    |> Tuple.sum()
  end

  def population_stream(initial_day) do
    day_pops = Enum.frequencies(initial_day)

    acc =
      0..8
      |> Enum.map(&Map.get(day_pops, &1, 0))
      |> List.to_tuple()

    Stream.iterate(acc, fn {d0, d1, d2, d3, d4, d5, d6, d7, d8} ->
      {d1, d2, d3, d4, d5, d6, d7 + d0, d8, d0}
    end)
  end
end
