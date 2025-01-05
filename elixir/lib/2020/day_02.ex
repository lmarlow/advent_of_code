defmodule AdventOfCode.Y2020.Day02 do
  @moduledoc """
  --- Day 2: Password Philosophy ---
  Problem Link: https://adventofcode.com/2020/day/2
  """
  use AdventOfCode.Helpers.InputReader, year: 2020, day: 2

  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  @doc """
  Sample data:

  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc
  """
  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [min, max, char, password] =
        Regex.run(~r/(\d+)-(\d+) (\w): (\w+)/, line, capture: :all_but_first)

      {String.to_integer(min), String.to_integer(max), char, password}
    end)
  end

  # --- <Solution Functions> ---

  def solve(data, 1) do
    data
    |> Enum.filter(fn {min, max, char, password} ->
      num_char = Enum.count(String.graphemes(password), &(&1 == char))
      num_char in min..max
    end)
    |> Enum.count()
  end

  def solve(data, 2) do
    data
    |> Enum.filter(fn {pos1, pos2, char, password} = _policy ->
      chars = String.graphemes(password)

      case [Enum.at(chars, pos1 - 1), Enum.at(chars, pos2 - 1)] do
        [^char, ^char] -> false
        [^char, _char] -> true
        [_char, ^char] -> true
        _ -> false
      end
    end)
    |> Enum.count()
  end

  # --- </Solution Functions> ---
end
