defmodule AdventOfCode.Y2021.Day17 do
  @moduledoc """
  --- Day 17: Trick Shot ---
  Problem Link: https://adventofcode.com/2021/day/17
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 17

  @doc ~S"""
  Sample data:

  ```
  target area: x=20..30, y=-10..-5
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> solve(part)

  def parse(data) do
    [x_min, x_max, y_min, y_max] =
      Regex.scan(~r/[-0-9]+/, data)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    {x_min..x_max, y_min..y_max}
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
    a = -1
    v = v0 + a(t-1) = v0 - t + 1 
    x = x0 + v0(t-1) + (1/2)a(t-1)^2 = v0(t-1) - (1/2)(t-1)^2
    s = (1 + n)n/2 = (1/2) * n^2 + (1/2) * n
    0 = n^2 + n - 2*s
  """
  def solve_1({xr, yr}) do
    vx_max = xr.last
    vx_min = quadratic(1, 1, -2 * xr.first)
    vxr = vx_min..vx_max

    vy_max = max(abs(yr.first), abs(yr.last))
    vyr = -vy_max..vy_max

    all_vs = for vx <- vxr, vy <- vyr, do: {vx, vy}

    all_vs
    |> Enum.map(&path(xr, yr, &1))
    |> Enum.filter(&hits_target(xr, yr, &1))
    |> Enum.map(&max_height/1)
    |> Enum.max()
  end

  @doc """
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  defp quadratic(a, b, c) do
    sqrt = round(:math.sqrt(b * b - 4 * a * c))
    div(-b + sqrt, 2 * a)
  end

  def path(xr, yr, v) do
    Stream.iterate({{0, 0}, v}, fn {{x, y}, {vx, vy}} ->
      p = {x + vx, y + vy}
      v = {max(0, vx - 1), vy - 1}
      {p, v}
    end)
    |> Enum.take_while(fn {{x, y}, _v} ->
      x <= xr.last && y >= yr.first
    end)
    |> Enum.map(fn {p, _v} -> p end)
  end

  def hits_target(xr, yr, path) do
    path
    |> List.last()
    |> then(fn {x, y} -> x in xr && y in yr end)
  end

  def max_height(path), do: path |> Enum.map(fn {_, y} -> y end) |> Enum.max()

  # --- </Solution Functions> ---
end
