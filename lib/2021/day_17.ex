defmodule AdventOfCode.Y2021.Day17 do
  @moduledoc """
  --- Day 17: Trick Shot ---
  Problem Link: https://adventofcode.com/2021/day/17
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 17

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
  """
  def solve_1(data) do
    {1, :not_implemented}
  end

  @doc """
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
end
