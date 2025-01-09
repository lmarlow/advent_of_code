defmodule AdventOfCode.Y2024.Day08 do
  @moduledoc """
  # Day 8: Resonant Collinearity

  Problem Link: https://adventofcode.com/2024/day/8
  """
  use AdventOfCode.Helpers.InputReader, year: 2024, day: 8

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

  You find yourselves on the [roof](/2016/day/25) of a top-secret Easter
  Bunny installation.

  While The Historians do their thing, you take a look at the familiar
  *huge antenna*. Much to your surprise, it seems to have been
  reconfigured to emit a signal that makes people 0.1% more likely to buy
  Easter Bunny brand
  <span title="They could have imitated delicious chocolate, but the mediocre chocolate is WAY easier to imitate.">Imitation
  Mediocre</span> Chocolate as a Christmas gift! Unthinkable!

  Scanning across the city, you find that there are actually many such
  antennas. Each antenna is tuned to a specific *frequency* indicated by a
  single lowercase letter, uppercase letter, or digit. You create a map
  (your puzzle input) of these antennas. For example:

    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............

  The signal only applies its nefarious effect at specific *antinodes*
  based on the resonant frequencies of the antennas. In particular, an
  antinode occurs at any point that is perfectly in line with two antennas
  of the same frequency - but only when one of the antennas is twice as
  far away as the other. This means that for any pair of antennas with the
  same frequency, there are two antinodes, one on either side of them.

  So, for these two antennas with frequency `a`, they create the two
  antinodes marked with `#`:

    ..........
    ...#......
    ..........
    ....a.....
    ..........
    .....a....
    ..........
    ......#...
    ..........
    ..........

  Adding a third antenna with the same frequency creates several more
  antinodes. It would ideally add four antinodes, but two are off the
  right side of the map, so instead it adds only two:

    ..........
    ...#......
    #.........
    ....a.....
    ........a.
    .....a....
    ..#.......
    ......#...
    ..........
    ..........

  Antennas with different frequencies don't create antinodes; `A` and `a`
  count as different frequencies. However, antinodes *can* occur at
  locations that contain antennas. In this diagram, the lone antenna with
  frequency capital `A` creates no antinodes but has a
  lowercase-`a`-frequency antinode at its location:

    ..........
    ...#......
    #.........
    ....a.....
    ........a.
    .....a....
    ..#.......
    ......A...
    ..........
    ..........

  The first example has antennas with two different frequencies, so the
  antinodes they create look like this, plus an antinode overlapping the
  topmost `A`-frequency antenna:

    ......#....#
    ...#....0...
    ....#0....#.
    ..#....0....
    ....0....#..
    .#....A.....
    ...#........
    #......#....
    ........A...
    .........A..
    ..........#.
    ..........#.

  Because the topmost `A`-frequency antenna overlaps with a `0`-frequency
  antinode, there are *`14`* total unique locations that contain an
  antinode within the bounds of the map.

  Calculate the impact of the signal. *How many unique locations within
  the bounds of the map contain an antinode?*

  """
  def solve_1(_data) do
    {1, :not_implemented}
  end

  @doc """
  # Part 2
  """
  def solve_2(_data) do
    {2, :not_implemented}
  end

  # --- </Solution Functions> ---
end
