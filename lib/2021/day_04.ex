defmodule AdventOfCode.Y2021.Day04 do
  @moduledoc """
  --- Day 4: Giant Squid ---
  Problem Link: https://adventofcode.com/2021/day/4
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 4

  defmodule Board do
    defstruct rows: [], winner?: false, turns: 0, score: 0

    def play(%Board{winner?: true} = board, _), do: board

    def play(%Board{rows: rows} = board, number) do
      rows =
        Enum.map(rows, fn row ->
          Enum.map(row, fn
            ^number -> false
            other -> other
          end)
        end)

      winner? = winner?(rows)
      %{board | rows: rows, winner?: winner?, turns: board.turns + 1, score: number * score(rows)}
    end

    defp winner?(rows) do
      any_winning_rows = Enum.find(rows, &(not Enum.any?(&1)))

      any_winning_cols =
        Enum.find(0..4, fn col ->
          not Enum.any?(Enum.map(rows, &Enum.at(&1, col)))
        end)

      if any_winning_rows || any_winning_cols, do: true, else: false
    end

    defp score(rows) do
      rows
      |> List.flatten()
      |> Enum.filter(& &1)
      |> Enum.sum()
    end
  end

  @doc ~S"""
  Sample data:

  ```
  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
  8  2 23  4 24
  21  9 14 16  7
  6 10  3 18  5
  1 12 20 15 19

  3 15  0  2 22
  9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
  2  0 12  3  7
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run({_drawings, _boards} = data, part), do: data |> solve(part)

  def parse(data) do
    [drawings | boards] =
      data
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)

    drawings = String.split(drawings, ",") |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn row -> String.split(row) |> Enum.map(&String.to_integer/1) end)
      |> Enum.chunk_every(5)
      |> Enum.map(&struct(Board, rows: &1))

    {drawings, boards}
  end

  def solve({drawings, boards}, 1), do: solve_1(drawings, boards)
  def solve({drawings, boards}, 2), do: solve_2(drawings, boards)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(drawings, boards) do
    play_stream(drawings, boards)
    |> Enum.flat_map(&Function.identity/1)
    |> Enum.find(&match?(%{winner?: true}, &1))
    |> Map.get(:score)
  end

  @doc """
  """
  def solve_2(drawings, boards) do
    [only_loser_left] =
      play_stream(drawings, boards)
      |> Stream.map(&Enum.reject(&1, fn board -> board.winner? end))
      |> Enum.find(&match?([_one_left], &1))

    drawings
    |> Enum.drop(only_loser_left.turns)
    |> Enum.reduce(only_loser_left, fn number, board -> Board.play(board, number) end)
    |> Map.get(:score)
  end

  # --- </Solution Functions> ---

  defp play_stream(drawings, boards) do
    drawings
    |> Stream.transform(boards, fn number, boards ->
      new_boards = Enum.map(boards, &Board.play(&1, number))
      {[new_boards], new_boards}
    end)
  end
end
