defmodule AdventOfCode.Y2021.Day07 do
  @moduledoc """
  --- Day 7: The Treachery of Whales ---
  Problem Link: https://adventofcode.com/2021/day/7
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 7

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
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    {min, max} = data |> Enum.min_max()

    possible_pos = {Enum.count(min..max), 1} |> Nx.iota() |> Nx.subtract(min)

    data
    |> Nx.tensor()
    |> Nx.subtract(possible_pos)
    |> Nx.abs()
    |> Nx.sum(axes: [1])
    |> Nx.reduce_min()
    |> Nx.to_number()
  end

  @doc """
  """
  def solve_2(data) do
    {min, max} = data |> Enum.min_max()

    possible_pos = {Enum.count(min..max), 1} |> Nx.iota() |> Nx.subtract(min)

    distances =
      data
      |> Nx.tensor()
      |> Nx.subtract(possible_pos)
      |> Nx.abs()

    distances
    |> Nx.multiply(Nx.add(distances, 1))
    |> Nx.right_shift(Nx.tensor(1))
    |> Nx.sum(axes: [1])
    |> Nx.reduce_min()
    |> Nx.to_number()
  end

  # --- </Solution Functions> ---
end
