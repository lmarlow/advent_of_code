defmodule AdventOfCode.Y2021.Day05 do
  @moduledoc """
  --- Day 5: Hydrothermal Venture ---
  Problem Link: https://adventofcode.com/2021/day/5
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 5

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
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Regex.scan(~r/\d+/, &1))
    |> Enum.map(&Enum.map(&1, fn [n] -> String.to_integer(n) end))
    |> Enum.map(&Enum.chunk_every(&1, 2))
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    data
    |> Enum.filter(fn [[x1, y1], [x2, y2]] -> x1 == x2 or y1 == y2 end)
    |> count_dangerous_points()
  end

  @doc """
  """
  def solve_2(data) do
    data
    |> count_dangerous_points()
  end

  # --- </Solution Functions> ---

  def points([x1, y1], [x2, y1]), do: Enum.zip(x1..x2, List.duplicate(y1, Enum.count(x1..x2)))

  def points([x1, y1], [x1, y2]), do: Enum.zip(List.duplicate(x1, Enum.count(y1..y2)), y1..y2)

  def points([x1, y1], [x2, y2]), do: Enum.zip(x1..x2, y1..y2)

  defp count_dangerous_points(points) do
    points
    |> Enum.flat_map(fn [p1, p2] -> points(p1, p2) end)
    |> Enum.reduce(%{}, fn p, acc ->
      Map.update(acc, p, 1, &(&1 + 1))
    end)
    |> Enum.count(fn {_, n} -> n > 1 end)
  end
end
