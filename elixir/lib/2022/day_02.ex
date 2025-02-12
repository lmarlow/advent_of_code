defmodule AdventOfCode.Y2022.Day02 do
  @moduledoc """
  # Day 2: Rock Paper Scissors

  Problem Link: https://adventofcode.com/2022/day/2
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 2

  @doc ~S"""
  Sample data:

  ```
  A Y
  B X
  C Z
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  The Elves begin to set up camp on the beach. To decide whose tent gets
  to be closest to the snack storage, a giant
  <a href="https://en.wikipedia.org/wiki/Rock_paper_scissors"
  target="_blank">Rock Paper Scissors</a> tournament is already in
  progress.

  Rock Paper Scissors is a game between two players. Each game contains
  many rounds; in each round, the players each simultaneously choose one
  of Rock, Paper, or Scissors using a hand shape. Then, a winner for that
  round is selected: Rock defeats Scissors, Scissors defeats Paper, and
  Paper defeats Rock. If both players choose the same shape, the round
  instead ends in a draw.

  Appreciative of your help yesterday, one Elf gives you an *encrypted
  strategy guide* (your puzzle input) that they say will be sure to help
  you win. "The first column is what your opponent is going to play: `A`
  for Rock, `B` for Paper, and `C` for Scissors. The second column--"
  Suddenly, the Elf is called away to help with someone's tent.

  The second column, <span title="Why do you keep guessing?!">you
  reason</span>, must be what you should play in response: `X` for Rock,
  `Y` for Paper, and `Z` for Scissors. Winning every time would be
  suspicious, so the responses must have been carefully chosen.

  The winner of the whole tournament is the player with the highest score.
  Your *total score* is the sum of your scores for each round. The score
  for a single round is the score for the *shape you selected* (1 for
  Rock, 2 for Paper, and 3 for Scissors) plus the score for the *outcome
  of the round* (0 if you lost, 3 if the round was a draw, and 6 if you
  won).

  Since you can't be sure if the Elf is trying to help you or trick you,
  you should calculate the score you would get if you were to follow the
  strategy guide.

  For example, suppose you were given the following strategy guide:

      A Y
      B X
      C Z

  This strategy guide predicts and recommends the following:

  - In the first round, your opponent will choose Rock (`A`), and you
    should choose Paper (`Y`). This ends in a win for you with a score of
    *8* (2 because you chose Paper + 6 because you won).
  - In the second round, your opponent will choose Paper (`B`), and you
    should choose Rock (`X`). This ends in a loss for you with a score of
    *1* (1 + 0).
  - The third round is a draw with both players choosing Scissors, giving
    you a score of 3 + 3 = *6*.

  In this example, if you were to follow the strategy guide, you would get
  a total score of *`15`* (8 + 1 + 6).

  *What would your total score be if everything goes exactly according to
  your strategy guide?*

  """
  def solve_1(data) do
    data
    |> Enum.map(fn
      ~w[A X] -> 1 + 3
      ~w[A Y] -> 2 + 6
      ~w[A Z] -> 3 + 0
      ~w[B X] -> 1 + 0
      ~w[B Y] -> 2 + 3
      ~w[B Z] -> 3 + 6
      ~w[C X] -> 1 + 6
      ~w[C Y] -> 2 + 0
      ~w[C Z] -> 3 + 3
    end)
    |> Enum.sum()
  end

  @doc """
  # Part 2
  """
  def solve_2(data) do
    data
    |> Enum.map(fn
      ~w[A X] -> 3 + 0
      ~w[A Y] -> 1 + 3
      ~w[A Z] -> 2 + 6
      ~w[B X] -> 1 + 0
      ~w[B Y] -> 2 + 3
      ~w[B Z] -> 3 + 6
      ~w[C X] -> 2 + 0
      ~w[C Y] -> 3 + 3
      ~w[C Z] -> 1 + 6
    end)
    |> Enum.sum()
  end

  # --- </Solution Functions> ---
end
