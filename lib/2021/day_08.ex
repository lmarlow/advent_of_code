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
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  Solved with cut | grep | wc -l and adding

  ```shell
  ❯ cut -d' ' -f 12- priv/input_files/2021_08.txt | grep -E '\<\w\w\w\w\w\w\w\w\>' -o | wc -l
         0

  ❯ cut -d' ' -f 12- priv/input_files/2021_08.txt | grep -E '\<\w\w\w\w\w\w\w\>' -o | wc -l
        78

  ❯ cut -d' ' -f 12- priv/input_files/2021_08.txt | grep -E '\<\w\w\w\w\>' -o | wc -l
        78

  ❯ cut -d' ' -f 12- priv/input_files/2021_08.txt | grep -E '\<\w\w\w\>' -o | wc -l
        82

  ❯ cut -d' ' -f 12- priv/input_files/2021_08.txt | grep -E '\<\w\w\>' -o | wc -l
        92
  ````
  """
  def solve_1(_data) do
    330
  end

  @doc """
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
end
