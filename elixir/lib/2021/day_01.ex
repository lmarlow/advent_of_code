defmodule AdventOfCode.Y2021.Day01 do
  @moduledoc """
  --- Day 1: Sonar Sweep ---
  Problem Link: https://adventofcode.com/2021/day/1
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 1

  def run_1(data \\ input!())

  def run_1(data) when is_binary(data), do: data |> parse() |> run_1()

  def run_1(data) when is_list(data), do: data |> count_depth_increases()

  def run_2(data \\ input!())

  def run_2(data) when is_binary(data), do: data |> parse() |> run_2()

  def run_2(data) when is_list(data), do: data |> sum_sliding_windows() |> count_depth_increases()

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def count_depth_increases(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [first, second] -> first < second end)
  end

  def sum_sliding_windows(list) do
    list
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
  end
end
