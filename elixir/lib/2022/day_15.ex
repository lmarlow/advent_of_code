defmodule AdventOfCode.Y2022.Day15 do
  @moduledoc """
  # Day 15: Beacon Exclusion Zone

  Problem Link: https://adventofcode.com/2022/day/15
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 15

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    Regex.scan(
      ~r/Sensor at x=(?<x0>-?\d+), y=(?<y0>-?\d+): closest beacon is at x=(?<x1>-?\d+), y=(?<y1>-?\d+)/,
      data,
      capture: :all_but_first
    )
    |> Enum.map(fn str_coords -> Enum.map(str_coords, &String.to_integer/1) end)
    |> Enum.map(fn [x0, y0, x1, y1] ->
      {{x0, y0}, {x1, y1}}
    end)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  You feel the ground rumble again as the distress signal leads you to a
  large network of subterranean tunnels. You don't have time to search
  them all, but you don't need to: your pack contains a set of deployable
  *sensors* that you imagine were originally built to locate lost Elves.

  The sensors aren't very powerful, but that's okay; your handheld device
  indicates that you're close enough to the source of the distress signal
  to use them. You pull the emergency sensor system out of your pack, hit
  the big button on top, and the sensors zoom off down the tunnels.

  Once a sensor finds a spot it thinks will give it a good reading, it
  attaches itself to a hard surface and begins monitoring for the nearest
  signal source *beacon*. Sensors and beacons always exist at integer
  coordinates. Each sensor knows its own position and can *determine the
  position of a beacon precisely*; however, sensors can only lock on to
  the one beacon *closest to the sensor* as measured by the
  <a href="https://en.wikipedia.org/wiki/Taxicab_geometry"
  target="_blank">Manhattan distance</a>. (There is never a tie where two
  beacons are the same distance to a sensor.)

  It doesn't take long for the sensors to report back their positions and
  closest beacons (your puzzle input). For example:

      Sensor at x=2, y=18: closest beacon is at x=-2, y=15
      Sensor at x=9, y=16: closest beacon is at x=10, y=16
      Sensor at x=13, y=2: closest beacon is at x=15, y=3
      Sensor at x=12, y=14: closest beacon is at x=10, y=16
      Sensor at x=10, y=20: closest beacon is at x=10, y=16
      Sensor at x=14, y=17: closest beacon is at x=10, y=16
      Sensor at x=8, y=7: closest beacon is at x=2, y=10
      Sensor at x=2, y=0: closest beacon is at x=2, y=10
      Sensor at x=0, y=11: closest beacon is at x=2, y=10
      Sensor at x=20, y=14: closest beacon is at x=25, y=17
      Sensor at x=17, y=20: closest beacon is at x=21, y=22
      Sensor at x=16, y=7: closest beacon is at x=15, y=3
      Sensor at x=14, y=3: closest beacon is at x=15, y=3
      Sensor at x=20, y=1: closest beacon is at x=15, y=3

  So, consider the sensor at `2,18`; the closest beacon to it is at
  `-2,15`. For the sensor at `9,16`, the closest beacon to it is at
  `10,16`.

  Drawing sensors as `S` and beacons as `B`, the above arrangement of
  sensors and beacons looks like this:

                     1    1    2    2
           0    5    0    5    0    5
       0 ....S.......................
       1 ......................S.....
       2 ...............S............
       3 ................SB..........
       4 ............................
       5 ............................
       6 ............................
       7 ..........S.......S.........
       8 ............................
       9 ............................
      10 ....B.......................
      11 ..S.........................
      12 ............................
      13 ............................
      14 ..............S.......S.....
      15 B...........................
      16 ...........SB...............
      17 ................S..........B
      18 ....S.......................
      19 ............................
      20 ............S......S........
      21 ............................
      22 .......................B....

  This isn't necessarily a comprehensive map of all beacons in the area,
  though. Because each sensor only identifies its closest beacon, if a
  sensor detects a beacon, you know there are no other beacons that close
  or closer to that sensor. There could still be beacons that just happen
  to not be the closest beacon to any sensor. Consider the sensor at
  `8,7`:

                     1    1    2    2
           0    5    0    5    0    5
      -2 ..........#.................
      -1 .........###................
       0 ....S...#####...............
       1 .......#######........S.....
       2 ......#########S............
       3 .....###########SB..........
       4 ....#############...........
       5 ...###############..........
       6 ..#################.........
       7 .#########S#######S#........
       8 ..#################.........
       9 ...###############..........
      10 ....B############...........
      11 ..S..###########............
      12 ......#########.............
      13 .......#######..............
      14 ........#####.S.......S.....
      15 B........###................
      16 ..........#SB...............
      17 ................S..........B
      18 ....S.......................
      19 ............................
      20 ............S......S........
      21 ............................
      22 .......................B....

  This sensor's closest beacon is at `2,10`, and so you know there are no
  beacons that close or closer (in any positions marked `#`).

  None of the detected beacons seem to be producing the distress signal,
  so you'll need to <span
  title="&quot;When you have eliminated all which is impossible, then whatever remains, however improbable, must be where the missing beacon is.&quot; - Sherlock Holmes">work
  out</span> where the distress beacon is by working out where it *isn't*.
  For now, keep things simple by counting the positions where a beacon
  cannot possibly be along just a single row.

  So, suppose you have an arrangement of beacons and sensors like in the
  example above and, just in the row where `y=10`, you'd like to count the
  number of positions a beacon cannot possibly exist. The coverage from
  all sensors near that row looks like this:

                       1    1    2    2
             0    5    0    5    0    5
       9 ...#########################...
      10 ..####B######################..
      11 .###S#############.###########.

  In this example, in the row where `y=10`, there are *`26`* positions
  where a beacon cannot be present.

  Consult the report from the sensors you just deployed. *In the row where
  `y=2000000`, how many positions cannot contain a beacon?*

  """
  def solve_1(data) do
    row = if length(data) < 40, do: 10, else: 2_000_000

    row_beacons =
      for {_, {bx, ^row}} <- data, into: MapSet.new() do
        bx
      end

    for {{sx, sy} = s, b} <- data,
        d = distance(s, b),
        y = row,
        row_d = distance(s, {sx, y}),
        row_d <= d,
        dx = abs(y - sy),
        reduce: MapSet.new() do
      acc ->
        (sx - (d - dx))..(sx + (d - dx))
        |> MapSet.new()
        |> MapSet.union(acc)
    end
    |> MapSet.difference(row_beacons)
    |> Enum.count()
  end

  @doc """
  # Part 2

  Your handheld device indicates that the distress signal is coming from a
  beacon nearby. The distress beacon is not detected by any sensor, but
  the distress beacon must have `x` and `y` coordinates each no lower than
  `0` and no larger than `4000000`.

  To isolate the distress beacon's signal, you need to determine its
  *tuning frequency*, which can be found by multiplying its `x` coordinate
  by `4000000` and then adding its `y` coordinate.

  In the example above, the search space is smaller: instead, the `x` and
  `y` coordinates can each be at most `20`. With this reduced search area,
  there is only a single position that could have a beacon: `x=14, y=11`.
  The tuning frequency for this distress beacon is *`56000011`*.

  Find the only possible position for the distress beacon. *What is its
  tuning frequency?*
  """
  def solve_2(data) do
    max_sq = if length(data) < 40, do: 20, else: 4_000_000
    sensor_perimeter_distances = for {s, b} <- data, into: %{}, do: {s, distance(s, b) + 1}

    possible_points =
      sensor_perimeter_distances
      |> Task.async_stream(
        fn {{sx, sy}, d} ->
          for x <- max(0, sx - d)..min(sx + d, max_sq),
              abs_dy = d - abs(sx - x),
              y <- [max(0, sy - abs_dy), min(sy + abs_dy, max_sq)],
              Enum.all?(sensor_perimeter_distances, fn {s2, d2} -> distance({x, y}, s2) >= d2 end),
              into: [] do
            {x, y}
          end
        end,
        timeout: 120_000
      )
      |> Enum.flat_map(fn {:ok, list} -> list end)
      |> Enum.into(MapSet.new())

    [{x, y}] = Enum.take(possible_points, 1)
    x * 4_000_000 + y
  end

  # --- </Solution Functions> ---

  def distance({x0, y0} = _p1, {x1, y1} = _p2) do
    abs(x0 - x1) + abs(y0 - y1)
  end
end
