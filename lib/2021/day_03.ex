defmodule AdventOfCode.Y2021.Day03 do
  @moduledoc """
  --- Day 3: Binary Diagnostic ---
  Problem Link: https://adventofcode.com/2021/day/3
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 3

  @doc """
  Sample data:

  ```
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
    [gamma, epsilon] =
      data
      |> digits_by_index()
      |> digits_by_popularity()
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.to_integer(&1, 2))

    gamma * epsilon
  end

  @doc """
  """
  def solve_2(data) do
    [o2_key, co2_key] =
      data
      |> digits_by_index()
      |> digits_by_popularity()

    o2_line = find_by_key(data, hd(o2_key), 0, 0)
    co2_line = find_by_key(data, hd(co2_key), 0, 1)

    String.to_integer(o2_line, 2) * String.to_integer(co2_line, 2)
  end

  defp find_by_key([one_left], _bit, _index, _key_pos), do: one_left

  defp find_by_key(data, key, index, key_pos) do
    remaining = Enum.filter(data, &(String.at(&1, index) == key))

    next_key =
      remaining
      |> digits_by_index()
      |> digits_by_popularity()
      |> Enum.at(key_pos)
      |> Enum.at(index + 1)

    find_by_key(remaining, next_key, index + 1, key_pos)
  end

  defp digits_by_index(data) do
    data
    |> Enum.map(fn line -> line |> String.graphemes() |> Enum.with_index() end)
    |> Enum.reduce(%{}, fn bits_by_index, acc ->
      for {bit, index} <- bits_by_index, reduce: acc do
        acc -> Map.update(acc, index, [bit], &[bit | &1])
      end
    end)
    |> Enum.sort_by(fn {pos, _} -> pos end)
  end

  defp digits_by_popularity(data) do
    data
    |> Enum.map(fn {_pos, bits} ->
      {ones, zeroes} = Enum.split_with(bits, &(&1 == "1"))

      if length(ones) >= length(zeroes) do
        {"1", "0"}
      else
        {"0", "1"}
      end
    end)
    |> Enum.unzip()
    |> Tuple.to_list()
  end

  # --- </Solution Functions> ---
end
