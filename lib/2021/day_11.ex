defmodule AdventOfCode.Y2021.Day11 do
  @moduledoc """
  --- Day 11: Dumbo Octopus ---
  Problem Link: https://adventofcode.com/2021/day/11
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 11

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> Nx.tensor()
    |> Nx.subtract(?0)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    data
    |> flashes(100)
    |> elem(1)
  end

  @doc """
  """
  def solve_2(data) do
    all_flashed = Nx.broadcast(0, Nx.shape(data))

    data
    |> Stream.iterate(&step/1)
    |> Stream.with_index()
    |> Enum.find(fn {step, _} -> step == all_flashed end)
    |> elem(1)
  end

  # --- </Solution Functions> ---

  @neighbor_mask Nx.tensor([[1, 1, 1], [1, 0, 1], [1, 1, 1]])

  def flashes(grid, steps) do
    for _step <- 1..steps, reduce: {grid, 0} do
      {grid, flash_count} ->
        stepped = step(grid)
        new_flashes = stepped |> Nx.logical_not() |> Nx.sum() |> Nx.to_number()
        {stepped, flash_count + new_flashes}
    end
  end

  def step(grid) do
    stepped = Nx.add(grid, 1)
    boost(stepped, flashers(stepped), Nx.broadcast(0, Nx.shape(grid)))
  end

  def boost(grid, flashers, flashers), do: grid |> Nx.multiply(Nx.logical_not(flashers))

  def boost(grid, current_flashers, last_flashers) do
    padded = Nx.pad(grid, 0, [{1, 1, 0}, {1, 1, 0}])
    zeroes = Nx.broadcast(0, Nx.shape(padded))
    {rows, cols} = Nx.shape(grid)
    new_flashers = Nx.logical_xor(current_flashers, last_flashers)

    boosts =
      for x <- 1..cols, y <- 1..rows, reduce: zeroes do
        acc ->
          if new_flashers[y - 1][x - 1] |> Nx.to_number() == 1 do
            zeroes
            |> Nx.put_slice([y - 1, x - 1], @neighbor_mask)
            |> Nx.add(acc)
          else
            acc
          end
      end
      |> Nx.slice([1, 1], [rows, cols])

    boosted = Nx.add(grid, boosts)
    next_flashers = flashers(boosted)
    boost(boosted, next_flashers, Nx.logical_or(new_flashers, last_flashers))
  end

  defp flashers(grid), do: Nx.greater(grid, 9)
end
