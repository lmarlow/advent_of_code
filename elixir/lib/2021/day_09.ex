defmodule AdventOfCode.Y2021.Day09 do
  @moduledoc """
  --- Day 9: Smoke Basin ---
  Problem Link: https://adventofcode.com/2021/day/9
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 9

  @doc ~S"""
  Sample data:

  ```
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> Nx.tensor() |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.to_charlist(line) |> Enum.map(&(&1 - ?0)) end)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    {rows, cols} = Nx.shape(data)
    {maxy, maxx} = {rows - 1, cols - 1}

    for y <- 0..maxy,
        x <- 0..maxx,
        p = {y, x},
        v = value(p, data),
        reduce: 0 do
      acc ->
        neighbors(p, data)
        |> Enum.all?(&(value(&1, data) > v))
        |> then(&(acc + ((&1 && v + 1) || 0)))
    end
  end

  @doc """
  """
  def solve_2(data) do
    {rows, cols} = Nx.shape(data)
    {maxy, maxx} = {rows - 1, cols - 1}

    basins(data, {0, 0}, [], MapSet.new(), maxy, maxx)
    |> Enum.filter(&Enum.any?/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  # --- </Solution Functions> ---

  def neighbors({y, x}, data) do
    {rows, cols} = Nx.shape(data)
    {maxy, maxx} = {rows - 1, cols - 1}

    for {dy, dx} <- [{0, 1}, {0, -1}, {1, 0}, {-1, 0}],
        (y + dy) in 0..maxy,
        (x + dx) in 0..maxx,
        do: {y + dy, x + dx}
  end

  def value({y, x}, data), do: data[y][x] |> Nx.to_number()

  defp basins(_data, {y, _x}, acc, _visited, maxy, _maxx) when y > maxy, do: acc

  defp basins(data, {y, maxx}, acc, visited, maxy, maxx) do
    basins(data, {y + 1, 0}, acc, visited, maxy, maxx)
  end

  defp basins(data, {y, x} = p, acc, visited, maxy, maxx) do
    {basin, visited} =
      spider(
        data,
        p,
        value(p, data),
        MapSet.member?(visited, p),
        MapSet.new(),
        MapSet.put(visited, p)
      )

    basins(data, {y, x + 1}, [basin | acc], visited, maxy, maxx)
  end

  defp spider(_data, _p, _val, true = _visited?, basin, visited),
    do: {basin, visited}

  defp spider(_data, _p, too_big, false = _visited?, basin, visited) when too_big > 8,
    do: {basin, visited}

  defp spider(data, p, _val, false = _visited?, basin, visited) do
    Enum.reduce(
      neighbors(p, data),
      {MapSet.put(basin, p), visited},
      fn neighbor, {basin, visited} ->
        spider(
          data,
          neighbor,
          value(neighbor, data),
          MapSet.member?(visited, neighbor),
          basin,
          MapSet.put(visited, neighbor)
        )
      end
    )
  end
end
