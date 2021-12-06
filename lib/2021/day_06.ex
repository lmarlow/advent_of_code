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
    |> population_stream()
    |> Enum.at(80)
  end

  @doc """
  """
  def solve_2(data) do
    data
    |> population_stream()
    |> Enum.at(256)
  end

  # --- </Solution Functions> ---

  defp population_stream(initial_day) do
    initial_day
    |> Enum.reduce(%{}, fn age, acc -> Map.update(acc, age, 1, &(&1 + 1)) end)
    |> Stream.iterate(fn acc ->
      breed_pop = Map.get(acc, 0, 0)

      0..7
      |> Map.new(&{&1, Map.get(acc, &1 + 1, 0)})
      |> Map.update(6, breed_pop, &(&1 + breed_pop))
      |> Map.put(8, breed_pop)
    end)
    |> Stream.map(&(&1 |> Map.values() |> Enum.sum()))
  end
end
