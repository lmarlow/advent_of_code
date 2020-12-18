defmodule AdventOfCode.Y2020.Day17 do
  @moduledoc """
  Problem Link: https://adventofcode.com/2020/day/17
  """
  use AdventOfCode.Helpers.InputReader, year: 2020, day: 17

  def run_1, do: {:not_implemented, 1}
  def run_2, do: {:not_implemented, 2}
  def run, do: {run_1(), run_2()}

  def process(input \\ input!()) do
    input
    |> String.split("\n", trim: true)
  end
end
