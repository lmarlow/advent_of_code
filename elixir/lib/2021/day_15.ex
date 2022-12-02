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
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&Enum.map(String.to_charlist(&1), fn c -> c - ?0 end))
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    grid = to_grid(data)

    path({0, 0}, Enum.max(Map.keys(grid)), grid)
  end

  @doc """
  """
  def solve_2(data) do
    grid =
      data
      |> to_grid()
      |> expand_data(5)

    path({0, 0}, Enum.max(Map.keys(grid)), grid)
  end

  def path(start, target, grid) do
    distances = %{start => 0}
    queue = pq([], 0, start)
    path(grid, target, distances, queue)
  end

  def path(grid, target, distances, queue) do
    [{_shortest_dist, {row, col} = u} | queue] = queue

    if u == target do
      distances[u]
    else
      {distances, queue} =
        for v <- [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}],
            Map.has_key?(grid, v),
            alt = grid[v] + distances[u],
            alt < Map.get(distances, v, :infinity),
            reduce: {distances, queue} do
          {distances, queue} ->
            {Map.put(distances, v, alt), pq(queue, alt, v)}
        end

      path(grid, target, distances, queue)
    end
  end

  defp pq([{w1, _} | _] = q, w0, v) when w0 <= w1, do: [{w0, v} | q]

  defp pq([head | tail], w, v), do: [head | pq(tail, w, v)]

  defp pq([], w, v), do: [{w, v}]

  def to_grid(rows) do
    for {row, row_num} <- Enum.with_index(rows),
        {val, col_num} <- Enum.with_index(row),
        into: %{} do
      {{row_num, col_num}, val}
    end
  end

  # --- </Solution Functions> ---

  def expand_data(grid, n) do
    {max_row, max_col} = Enum.max(Map.keys(grid))
    new_max_row = (max_row + 1) * n - 1
    new_max_col = (max_col + 1) * n - 1

    for row <- 0..new_max_row, col <- 0..new_max_col, new_pos = {row, col}, into: %{} do
      inc = div(row, max_row + 1) + div(col, max_col + 1)
      pos = {rem(row, max_row + 1), rem(col, max_col + 1)}
      old_val = Map.fetch!(grid, pos)

      case old_val + inc do
        new_val when new_val < 10 -> {new_pos, new_val}
        new_val -> {new_pos, rem(new_val, 10) + 1}
      end
    end
  end
end
