defmodule AdventOfCode.Y2021.Day10 do
  @moduledoc """
  --- Day 10: Syntax Scoring ---
  Problem Link: https://adventofcode.com/2021/day/10
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 10

  @doc ~S"""
  Sample data:

  ```
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
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
    data
    |> Enum.map(&first_illegal_instruction/1)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  @doc """
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---

  defp first_illegal_instruction(bin) do
    first_illegal_instruction(bin, [])
  end

  defp first_illegal_instruction(<<>>, _stack) do
    ""
  end

  defp first_illegal_instruction("(" <> rest, stack) do
    first_illegal_instruction(rest, [")" | stack])
  end

  defp first_illegal_instruction("[" <> rest, stack) do
    first_illegal_instruction(rest, ["]" | stack])
  end

  defp first_illegal_instruction("{" <> rest, stack) do
    first_illegal_instruction(rest, ["}" | stack])
  end

  defp first_illegal_instruction("<" <> rest, stack) do
    first_illegal_instruction(rest, [">" | stack])
  end

  defp first_illegal_instruction(<<close::binary-size(1), rest::binary>>, [close | stack]) do
    first_illegal_instruction(rest, stack)
  end

  defp first_illegal_instruction(<<wrong_close::binary-size(1), _rest::binary>>, _stack) do
    wrong_close
  end

  defp score(")"), do: 3
  defp score("]"), do: 57
  defp score("}"), do: 1197
  defp score(">"), do: 25137
  defp score(_), do: 0
end
