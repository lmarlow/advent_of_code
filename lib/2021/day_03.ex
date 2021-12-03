defmodule AdventOfCode.Y2021.Day03 do
  @moduledoc """
  --- Day 3: Binary Diagnostic ---
  Problem Link: https://adventofcode.com/2021/day/3
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 3

  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
  end

  # --- <Solution Functions> ---

  @doc """
  """
  def solve(data, 1) do
    {1, :not_implemented}
  end

  @doc """
  """
  def solve(data, 2) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
end
