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
    |> Enum.map(&interpret/1)
    |> Enum.filter(&match?({:error, :corrupt, _}, &1))
    |> Enum.map(&elem(&1, 2))
    |> Enum.map(&score_corrupt/1)
    |> Enum.sum()
  end

  @doc """
  """
  def solve_2(data) do
    data
    |> Enum.map(&interpret/1)
    |> Enum.filter(&match?({:error, :unfinished, _}, &1))
    |> Enum.map(&elem(&1, 2))
    |> Enum.map(&score_completion/1)
    |> total_completion_score()
  end

  # --- </Solution Functions> ---

  def interpret(code) do
    interpret(code, [])
  end

  defp interpret(<<>>, []) do
    :ok
  end

  defp interpret(<<>>, [_ | _] = unfinished_stack) do
    {:error, :unfinished, unfinished_stack}
  end

  defp interpret("(" <> rest, stack) do
    interpret(rest, [")" | stack])
  end

  defp interpret("[" <> rest, stack) do
    interpret(rest, ["]" | stack])
  end

  defp interpret("{" <> rest, stack) do
    interpret(rest, ["}" | stack])
  end

  defp interpret("<" <> rest, stack) do
    interpret(rest, [">" | stack])
  end

  defp interpret(<<close::binary-size(1), rest::binary>>, [close | stack]) do
    interpret(rest, stack)
  end

  defp interpret(<<wrong_close::binary-size(1), _rest::binary>>, _stack) do
    {:error, :corrupt, wrong_close}
  end

  defp score_corrupt(")"), do: 3
  defp score_corrupt("]"), do: 57
  defp score_corrupt("}"), do: 1197
  defp score_corrupt(">"), do: 25137
  defp score_corrupt(_), do: 0

  defp score_completion(code) do
    Enum.reduce(code, 0, fn char, score ->
      score * 5 + unfinished_point(char)
    end)
  end

  def total_completion_score(scores) do
    Enum.at(Enum.sort(scores), div(length(scores), 2))
  end

  defp unfinished_point(")"), do: 1
  defp unfinished_point("]"), do: 2
  defp unfinished_point("}"), do: 3
  defp unfinished_point(">"), do: 4
end
