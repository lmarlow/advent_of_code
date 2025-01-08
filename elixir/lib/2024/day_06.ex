defmodule AdventOfCode.Y2024.Day06 do
  @moduledoc """
  # Day 6: Guard Gallivant

  Problem Link: https://adventofcode.com/2024/day/6
  """
  use AdventOfCode.Helpers.InputReader, year: 2024, day: 6

  @doc ~S"""
  Sample data:

  ```
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
  # Part 1

  The Historians use their fancy [device](4) again, this time to whisk you
  all away to the North Pole prototype suit manufacturing lab... in the
  year [1518](/2018/day/5)! It turns out that having direct access to
  history is very convenient for a group of historians.

  You still have to be careful of time paradoxes, and so it will be
  important to avoid anyone from 1518 while The Historians search for the
  Chief. Unfortunately, a single *guard* is patrolling this part of the
  lab.

  Maybe you can work out where the guard will go ahead of time so that The
  Historians can search safely?

  You start by making a map (your puzzle input) of the situation. For
  example:

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...

  The map shows the current position of the guard with `^` (to indicate
  the guard is currently facing *up* from the perspective of the map). Any
  *obstructions* - crates, desks, alchemical reactors, etc. - are shown as
  `#`.

  Lab guards in 1518 follow a very strict patrol protocol which involves
  repeatedly following these steps:

  - If there is something directly in front of you, turn right 90 degrees.
  - Otherwise, take a step forward.

  Following the above protocol, the guard moves up several times until she
  reaches an obstacle (in this case, a pile of failed suit prototypes):

    ....#.....
    ....^....#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#...

  Because there is now an obstacle in front of the guard, she turns right
  before continuing straight in her new facing direction:

    ....#.....
    ........>#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#...

  Reaching another obstacle (a spool of several *very* long polymers), she
  turns right again and continues downward:

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#......v.
    ........#.
    #.........
    ......#...

  This process continues for a while, but the guard eventually leaves the
  mapped area (after walking past a tank of universal solvent):

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#v..

  By predicting the guard's route, you can determine which specific
  positions in the lab will be in the patrol path. *Including the guard's
  starting position*, the positions visited by the guard before leaving
  the area are marked with an `X`:

    ....#.....
    ....XXXXX#
    ....X...X.
    ..#.X...X.
    ..XXXXX#X.
    ..X.X.X.X.
    .#XXXXXXX.
    .XXXXXXX#.
    #XXXXXXX..
    ......#X..

  In this example, the guard will visit *`41`* distinct positions on your
  map.

  Predict the path of the guard. *How many distinct positions will the
  guard visit before leaving the mapped area?*

  """
  def solve_1(data) do
    map =
      for {line, y} <- Enum.with_index(data),
          {char, x} <- Enum.with_index(String.graphemes(line)),
          into: %{},
          do: {{x, y}, char}

    # max_y = Enum.count(data) - 1
    # max_x = Enum.count(String.graphemes(hd(data))) - 1

    {start_position, direction} =
      Enum.find(map, fn {_position, direction} -> direction in ["^", ">", "v", "<"] end)

    {start_position, velocity(direction)}
    |> Stream.unfold(fn {position, velocity} ->
      with {new_position, new_velocity, <<_::binary>>} <- walk(map, position, velocity) do
        {{new_position, new_velocity}, {new_position, new_velocity}}
      else
        _other -> nil
      end
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
    |> Enum.count()
  end

  @doc """
  # Part 2
  """
  def solve_2(_data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
  defp velocity("^"), do: {0, -1}
  defp velocity(">"), do: {1, 0}
  defp velocity("v"), do: {0, 1}
  defp velocity("<"), do: {-1, 0}

  defp direction({0, -1}), do: "^"
  defp direction({1, 0}), do: ">"
  defp direction({0, 1}), do: "v"
  defp direction({-1, 0}), do: "<"

  defp turn({0, -1}), do: {1, 0}
  defp turn({1, 0}), do: {0, 1}
  defp turn({0, 1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, -1}

  defp walk(map, {x, y} = position, {dx, dy} = velocity) do
    new_position = {x + dx, y + dy}

    case Map.get(map, new_position) do
      "#" -> walk(map, position, turn(velocity))
      spot -> {new_position, velocity, spot}
    end
  end

  defp map_to_string(map, max_x, max_y) do
    for y <- 0..max_y, into: "" do
      line = for x <- 0..max_x, into: "", do: Map.get(map, {x, y}, ".")

      line <> "\n"
    end
  end
end
