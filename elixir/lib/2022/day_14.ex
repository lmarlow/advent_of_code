defmodule AdventOfCode.Y2022.Day14 do
  @moduledoc """
  # Day 14: Regolith Reservoir

  Problem Link: https://adventofcode.com/2022/day/14
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 14

  defstruct grid: %{}, bounds: {{0, 0}, {0, 0}}, sand_count: 0, full?: false

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
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ")
      |> Enum.map(
        &(&1
          |> String.split(",")
          |> Enum.map(fn n -> String.to_integer(n) end)
          |> List.to_tuple())
      )
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&List.to_tuple/1)
    end)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  The distress signal leads you to a giant waterfall! Actually, hang on -
  the signal seems like it's coming from the waterfall itself, and that
  doesn't make any sense. However, you do notice a little path that leads
  *behind* the waterfall.

  Correction: the distress signal leads you behind a giant waterfall!
  There seems to be a large cave system here, and the signal definitely
  leads further inside.

  As you begin to make your way deeper underground, you feel the ground
  rumble for a moment. Sand begins pouring into the cave! If you don't
  quickly figure out where the sand is going, you could quickly become
  trapped!

  Fortunately, your [familiarity](/2018/day/17) with analyzing the path of
  falling material will come in handy here. You scan a two-dimensional
  vertical slice of the cave above you (your puzzle input) and discover
  that it is mostly *air* with structures made of *rock*.

  Your scan traces the path of each solid rock structure and reports the
  `x,y` coordinates that form the shape of the path, where `x` represents
  distance to the right and `y` represents distance down. Each path
  appears as a single line of text in your scan. After the first point of
  each path, each point indicates the end of a straight horizontal or
  vertical line to be drawn from the previous point. For example:

      498,4 -> 498,6 -> 496,6
      503,4 -> 502,4 -> 502,9 -> 494,9

  This scan means that there are two paths of rock; the first path
  consists of two straight lines, and the second path consists of three
  straight lines. (Specifically, the first path consists of a line of rock
  from `498,4` through `498,6` and another line of rock from `498,6`
  through `496,6`.)

  The sand is pouring into the cave from point `500,0`.

  Drawing rock as `#`, air as `.`, and the source of the sand as `+`, this
  becomes:

        4     5  5
        9     0  0
        4     0  3
      0 ......+...
      1 ..........
      2 ..........
      3 ..........
      4 ....#...##
      5 ....#...#.
      6 ..###...#.
      7 ........#.
      8 ........#.
      9 #########.

  Sand is produced *one unit at a time*, and the next unit of sand is not
  produced until the previous unit of sand *comes to rest*. A unit of sand
  is large enough to fill one tile of air in your scan.

  A unit of sand always falls *down one step* if possible. If the tile
  immediately below is blocked (by rock or sand), the unit of sand
  attempts to instead move diagonally *one step down and to the left*. If
  that tile is blocked, the unit of sand attempts to instead move
  diagonally *one step down and to the right*. Sand keeps moving as long
  as it is able to do so, at each step trying to move down, then
  down-left, then down-right. If all three possible destinations are
  blocked, the unit of sand *comes to rest* and no longer moves, at which
  point the next unit of sand is created back at the source.

  So, drawing sand that has come to rest as `o`, the first unit of sand
  simply falls straight down and then stops:

      ......+...
      ..........
      ..........
      ..........
      ....#...##
      ....#...#.
      ..###...#.
      ........#.
      ......o.#.
      #########.

  The second unit of sand then falls straight down, lands on the first
  one, and then comes to rest to its left:

      ......+...
      ..........
      ..........
      ..........
      ....#...##
      ....#...#.
      ..###...#.
      ........#.
      .....oo.#.
      #########.

  After a total of five units of sand have come to rest, they form this
  pattern:

      ......+...
      ..........
      ..........
      ..........
      ....#...##
      ....#...#.
      ..###...#.
      ......o.#.
      ....oooo#.
      #########.

  After a total of 22 units of sand:

      ......+...
      ..........
      ......o...
      .....ooo..
      ....#ooo##
      ....#ooo#.
      ..###ooo#.
      ....oooo#.
      ...ooooo#.
      #########.

  Finally, only two more units of sand can possibly come to rest:

      ......+...
      ..........
      ......o...
      .....ooo..
      ....#ooo##
      ...o#ooo#.
      ..###ooo#.
      ....oooo#.
      .o.ooooo#.
      #########.

  Once all *`24`* units of sand shown above have come to rest, all further
  sand flows out the bottom, falling into the endless void. Just for fun,
  the path any new sand takes before falling forever is shown here with
  `~`:

      .......+...
      .......~...
      ......~o...
      .....~ooo..
      ....~#ooo##
      ...~o#ooo#.
      ..~###ooo#.
      ..~..oooo#.
      .~o.ooooo#.
      ~#########.
      ~..........
      ~..........
      ~..........

  Using your scan, simulate the falling sand. *How many units of sand come
  to rest before sand starts flowing into the abyss below?*

  """
  def solve_1(data) do
    data
    |> new()
    |> fill()
    |> Stream.drop_while(&(&1.full? == false))
    |> Enum.map(& &1.sand_count)
    |> Enum.max()
  end

  @doc """
  # Part 2

  You realize you misread the scan. There isn't an <span
  title="Endless Void is my C cover band.">endless void</span> at the
  bottom of the scan - there's floor, and you're standing on it!

  You don't have time to scan the floor, so assume the floor is an
  infinite horizontal line with a `y` coordinate equal to *two plus the
  highest `y` coordinate* of any point in your scan.

  In the example above, the highest `y` coordinate of any point is `9`,
  and so the floor is at `y=11`. (This is as if your scan contained one
  extra rock path like `-infinity,11 -> infinity,11`.) With the added
  floor, the example above now looks like this:

              ...........+........
              ....................
              ....................
              ....................
              .........#...##.....
              .........#...#......
              .......###...#......
              .............#......
              .............#......
              .....#########......
              ....................
      <-- etc #################### etc -->

  To find somewhere safe to stand, you'll need to simulate falling sand
  until a unit of sand comes to rest at `500,0`, blocking the source
  entirely and stopping the flow of sand into the cave. In the example
  above, the situation finally looks like this after *`93`* units of sand
  come to rest:

      ............o............
      ...........ooo...........
      ..........ooooo..........
      .........ooooooo.........
      ........oo#ooo##o........
      .......ooo#ooo#ooo.......
      ......oo###ooo#oooo......
      .....oooo.oooo#ooooo.....
      ....oooooooooo#oooooo....
      ...ooo#########ooooooo...
      ..ooooo.......ooooooooo..
      #########################

  Using your scan, simulate the falling sand until the source of the sand
  becomes blocked. *How many units of sand come to rest?*
  """
  def solve_2(data) do
    data
    |> new(true)
    |> fill()
    |> Stream.drop_while(&(&1.full? == false))
    |> Enum.map(& &1.sand_count)
    |> Enum.max()
  end

  # --- </Solution Functions> ---

  def new(data, include_floor? \\ false) do
    grid =
      for wall <- data,
          {{x0, y0}, {x1, y1}} <- wall,
          x <- x0..x1,
          y <- y0..y1,
          into: %{} do
        {{x, y}, "#"}
      end

    {xmin, xmax} = grid |> Map.keys() |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {ymin, ymax} = grid |> Map.keys() |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    {{xmin, _ymin}, {xmax, ymax}} =
      bounds =
      if include_floor? do
        {{min(xmin - 200, 500), min(ymin, 1)}, {max(xmax + 200, 500), max(ymax + 2, 1)}}
      else
        {{min(xmin, 500), min(ymin, 1)}, {max(xmax, 500), max(ymax, 1)}}
      end

    grid =
      if include_floor? do
        for x <- xmin..xmax, floor = {x, ymax}, into: grid, do: {floor, "#"}
      else
        grid
      end

    __MODULE__
    |> struct(grid: grid, bounds: bounds)
  end

  def fill(%{bounds: bounds} = cave) do
    drop_pos = {500, 0}
    cave = %{cave | grid: Map.put(cave.grid, drop_pos, "o")}

    Stream.unfold(
      {drop_pos, cave},
      fn
        :halt ->
          nil

        {{sand_x, sand_y} = prev_pos, %{grid: grid} = cave} ->
          down = {sand_x, sand_y + 1}
          left = {sand_x - 1, sand_y + 1}
          right = {sand_x + 1, sand_y + 1}

          next =
            [down, left, right]
            |> Enum.find(fn pos -> is_nil(Map.get(grid, pos)) end)

          cond do
            is_nil(next) and prev_pos == drop_pos ->
              {%{
                 cave
                 | grid: Map.put(cave.grid, drop_pos, "o"),
                   full?: true,
                   sand_count: cave.sand_count + 1
               }, :halt}

            is_nil(next) ->
              {cave, {drop_pos, %{cave | sand_count: cave.sand_count + 1}}}

            outside?(next, bounds) ->
              cave = move(cave, prev_pos, next, "~")
              {%{cave | full?: true}, :halt}

            true ->
              cave = move(cave, prev_pos, next)
              {cave, {next, cave}}
          end
      end
    )
  end

  def outside?({x, y}, {{xmin, ymin}, {xmax, ymax}}) do
    x < xmin or x > xmax or y < ymin or y > ymax
  end

  def move(%{grid: grid} = cave, prev, next, val \\ "o") do
    %{
      cave
      | grid:
          grid
          |> Map.delete(prev)
          |> Map.put(next, val)
    }
  end

  def to_string(%{grid: grid, bounds: {{xmin, ymin}, {xmax, ymax}}}) do
    {{xmin, ymin}, {xmax, ymax}} = {{xmin - 1, ymin - 1}, {xmax + 1, ymax + 1}}

    Enum.map_join(ymin..ymax, "\n", fn y ->
      Enum.map_join(xmin..xmax, fn x ->
        Map.get(grid, {x, y}, ".")
      end)
    end)
  end

  defimpl String.Chars do
    defdelegate to_string(cave), to: AdventOfCode.Y2022.Day14
  end

  def draw(%{grid: _grid} = cave), do: tap(cave, &IO.puts/1)
end
