defmodule AdventOfCode.Y2021.Day12 do
  @moduledoc """
  --- Day 12: Passage Pathing ---
  Problem Link: https://adventofcode.com/2021/day/12
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 12

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
    |> Enum.map(&String.split(&1, "-"))
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    data
    |> nodes()
    |> paths()
    |> length()
  end

  @doc """
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---

  def nodes(lines) do
    lines
    |> Enum.reduce(%{}, fn
      [a, b], acc ->
        acc
        |> Map.update(a, [b], &[b | &1])
        |> Map.update(b, [a], &[a | &1])
    end)
    |> Enum.map(fn {k, v} -> {k, v -- ["start"]} end)
    |> Map.new()
    |> Map.delete("end")
  end

  def paths(nodes) do
    "start"
    |> paths(nodes, [])
    |> List.flatten()
  end

  def paths("end", _nodes, path), do: ["end" | path] |> Enum.reverse() |> List.to_tuple()

  def paths(current_node, nodes, path) do
    if allowed?(current_node, path) do
      path = [current_node | path]

      for next <- nodes[current_node] do
        paths(next, nodes, path)
      end
    else
      []
    end
  end

  defp allowed?(node, path) do
    String.match?(node, ~r/[A-Z]+/) or node not in path
  end
end
