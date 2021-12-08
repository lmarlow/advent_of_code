defmodule AdventOfCode.Y2021.Day08 do
  @moduledoc """
  --- Day 8: Seven Segment Search ---
  Problem Link: https://adventofcode.com/2021/day/8
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 8

  @doc ~S"""
  Sample data:

  ```
  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([" ", "|"], trim: true)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&Enum.sort/1)
      |> Enum.split(10)
    end)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    data
    |> Enum.flat_map(fn {_notes, display} -> display end)
    |> Enum.map(&length/1)
    |> Enum.count(&(&1 in [2, 3, 4, 7]))
  end

  @doc """
  """
  def solve_2(data) do
    data
    |> Enum.map(&number/1)
    |> Enum.sum()
  end

  # --- </Solution Functions> ---

  defp number({notes, display}) do
    digit_map = digit_map(notes)

    display
    |> Enum.map(&digit_map[&1])
    |> Integer.undigits()
  end

  defp digit_map(_notes) do
    %{
      'abcdeg' => 0,
      'ab' => 1,
      'acdfg' => 2,
      'abcdf' => 3,
      'abef' => 4,
      'bcdef' => 5,
      'bcdefg' => 6,
      'abd' => 7,
      'abcdefg' => 8,
      'abcdef' => 9
    }
  end
end
