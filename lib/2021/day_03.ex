defmodule AdventOfCode.Y2021.Day03 do
  @moduledoc """
  --- Day 3: Binary Diagnostic ---
  Problem Link: https://adventofcode.com/2021/day/3
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 3

  @doc """
  Sample data:

  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
  end

  # --- <Solution Functions> ---

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  @doc """
  """
  def solve_1(data) do
    [gamma, epsilon] =
      data
      |> Enum.map(fn line -> line |> String.graphemes() |> Enum.with_index() end)
      |> Enum.reduce(%{}, fn bits_by_index, acc ->
        for {bit, index} <- bits_by_index, reduce: acc do
          acc -> Map.update(acc, index, [bit], &[bit | &1])
        end
      end)
      |> Enum.sort_by(fn {pos, _} -> pos end)
      |> Enum.map(fn {_pos, bits} ->
        {ones, zeroes} = Enum.split_with(bits, &(&1 == "1"))

        {gamma, epsilon} =
          if length(ones) >= length(zeroes) do
            {"1", "0"}
          else
            {"0", "1"}
          end

        {gamma, epsilon}
      end)
      |> Enum.unzip()
      |> Tuple.to_list()
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.to_integer(&1, 2))

    gamma * epsilon
  end

  @doc """
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
end
