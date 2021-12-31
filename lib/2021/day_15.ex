defmodule AdventOfCode.Y2021.Day15 do
  @moduledoc """
  --- Day 15: Chiton ---
  Problem Link: https://adventofcode.com/2021/day/15
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 15

  @doc ~S"""
  Sample data:

  ```
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part), do: data |> solve(part)

  def parse(data) do
    lines =
      data
      |> String.split("\n", trim: true)

    for {line, row_num} <- Enum.with_index(lines),
        {char_val, col_num} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{row_num, col_num}, char_val - ?0}
    end
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(grid) do
    rows =
      grid
      |> Enum.map(fn {{row, _}, _} -> row end)
      |> Enum.max()

    cols =
      grid
      |> Enum.map(fn {{_, col}, _} -> col end)
      |> Enum.max()

    path({0, 0}, {rows, cols}, grid)
  end

  @doc """
  """
  def solve_2(_data) do
    {2, :not_implemented}
  end

  def path(start, target, grid) do
    distances = %{start => 0}
    queue = MapSet.new(Map.keys(grid))
    path(grid, target, distances, queue)
  end

  def path(grid, target, distances, queue) do
    {row, col} = u = Enum.min_by(queue, &distances[&1])

    if u == target do
      distances[u]
    else
      queue = MapSet.delete(queue, u)

      distances =
        for v <- [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}],
            v in queue,
            alt = grid[v] + distances[u],
            alt < Map.get(distances, v, :infinity),
            reduce: distances do
          distances ->
            Map.put(distances, v, alt)
        end

      path(grid, target, distances, queue)
    end
  end

  # --- </Solution Functions> ---
end
