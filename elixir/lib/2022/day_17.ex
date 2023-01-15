defmodule AdventOfCode.Y2022.Day17 do
  @moduledoc """
  # Day 17: Pyroclastic Flow

  Problem Link: https://adventofcode.com/2022/day/17
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 17

  @type dir :: :left | :right | :down

  defmodule Rock do
    @type t() :: %__MODULE__{}

    defstruct name: nil, origin: {0, 0}, width: 0, height: 0, shape: []

    def new(name, shape) do
      {xs, ys} = Enum.unzip(shape)
      {xmin, xmax} = Enum.min_max(xs)
      {ymin, ymax} = Enum.min_max(ys)

      %__MODULE__{
        name: name,
        origin: {0, 0},
        width: 1 + xmax - xmin,
        height: 1 + ymax - ymin,
        shape: shape
      }
    end

    def move(%__MODULE__{origin: {x0, y0}} = rock, {dx, dy}) do
      %{rock | origin: {x0 + dx, y0 + dy}}
    end

    def move(%__MODULE__{} = rock, :left), do: move(rock, {-1, 0})
    def move(%__MODULE__{} = rock, :right), do: move(rock, {1, 0})
    def move(%__MODULE__{} = rock, :down), do: move(rock, {0, -1})

    def blocked?(%__MODULE__{} = rock, x_range, cave), do: not valid?(rock, x_range, cave)

    def valid?(%__MODULE__{} = rock, x_range, cave) do
      in_bounds?(rock, x_range) and MapSet.disjoint?(positions(rock), cave)
    end

    def positions(%__MODULE__{origin: {x0, y0}, shape: shape}) do
      MapSet.new(shape, fn {px, py} -> {px + x0, py + y0} end)
    end

    def out_of_bounds?(%__MODULE__{origin: {x0, y0}, width: w}, left..right//_) do
      x0 < left or x0 + (w - 1) > right or y0 < 0
    end

    def in_bounds?(%__MODULE__{} = rock, _.._//_ = range), do: not out_of_bounds?(rock, range)

    def top(%__MODULE__{origin: {_, y0}, height: h}), do: y0 + h
  end

  @cave_width 0..6

  @doc ~S"""
  Sample data:

  ```
  >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.trim()
    |> String.to_charlist()
    |> Enum.map(&if &1 == ?<, do: :left, else: :right)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  Your handheld device has located an alternative exit from the cave for
  you and the elephants. The ground is rumbling almost continuously now,
  but the strange valves bought you some time. It's definitely getting
  warmer in here, though.

  The tunnels eventually open into a very tall, narrow chamber. Large,
  oddly-shaped rocks are falling into the chamber from above, presumably
  due to all the rumbling. If you can't work out where the rocks will fall
  next, you might be <span
  title="I am the man who arranges the blocks / that descend upon me from up above!">crushed</span>!

  The five types of rocks have the following peculiar shapes, where `#` is
  rock and `.` is empty space:

      ####

      .#.
      ###
      .#.

      ..#
      ..#
      ###

      #
      #
      #
      #

      ##
      ##

  The rocks fall in the order shown above: first the `-` shape, then the
  `+` shape, and so on. Once the end of the list is reached, the same
  order repeats: the `-` shape falls first, sixth, 11th, 16th, etc.

  The rocks don't spin, but they do get pushed around by jets of hot gas
  coming out of the walls themselves. A quick scan reveals the effect the
  jets of hot gas will have on the rocks as they fall (your puzzle input).

  For example, suppose this was the jet pattern in your cave:

      >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>

  In jet patterns, `<` means a push to the left, while `>` means a push to
  the right. The pattern above means that the jets will push a falling
  rock right, then right, then right, then left, then left, then right,
  and so on. If the end of the list is reached, it repeats.

  The tall, vertical chamber is exactly *seven units wide*. Each rock
  appears so that its left edge is two units away from the left wall and
  its bottom edge is three units above the highest rock in the room (or
  the floor, if there isn't one).

  After a rock appears, it alternates between *being pushed by a jet of
  hot gas* one unit (in the direction indicated by the next symbol in the
  jet pattern) and then *falling one unit down*. If any movement would
  cause any part of the rock to move into the walls, floor, or a stopped
  rock, the movement instead does not occur. If a *downward* movement
  would have caused a falling rock to move into the floor or an
  already-fallen rock, the falling rock stops where it is (having landed
  on something) and a new rock immediately begins falling.

  Drawing falling rocks with `@` and stopped rocks with `#`, the jet
  pattern in the example above manifests as follows:

      The first rock begins falling:
      |..@@@@.|
      |.......|
      |.......|
      |.......|
      +-------+

      Jet of gas pushes rock right:
      |...@@@@|
      |.......|
      |.......|
      |.......|
      +-------+

      Rock falls 1 unit:
      |...@@@@|
      |.......|
      |.......|
      +-------+

      Jet of gas pushes rock right, but nothing happens:
      |...@@@@|
      |.......|
      |.......|
      +-------+

      Rock falls 1 unit:
      |...@@@@|
      |.......|
      +-------+

      Jet of gas pushes rock right, but nothing happens:
      |...@@@@|
      |.......|
      +-------+

      Rock falls 1 unit:
      |...@@@@|
      +-------+

      Jet of gas pushes rock left:
      |..@@@@.|
      +-------+

      Rock falls 1 unit, causing it to come to rest:
      |..####.|
      +-------+

      A new rock begins falling:
      |...@...|
      |..@@@..|
      |...@...|
      |.......|
      |.......|
      |.......|
      |..####.|
      +-------+

      Jet of gas pushes rock left:
      |..@....|
      |.@@@...|
      |..@....|
      |.......|
      |.......|
      |.......|
      |..####.|
      +-------+

      Rock falls 1 unit:
      |..@....|
      |.@@@...|
      |..@....|
      |.......|
      |.......|
      |..####.|
      +-------+

      Jet of gas pushes rock right:
      |...@...|
      |..@@@..|
      |...@...|
      |.......|
      |.......|
      |..####.|
      +-------+

      Rock falls 1 unit:
      |...@...|
      |..@@@..|
      |...@...|
      |.......|
      |..####.|
      +-------+

      Jet of gas pushes rock left:
      |..@....|
      |.@@@...|
      |..@....|
      |.......|
      |..####.|
      +-------+

      Rock falls 1 unit:
      |..@....|
      |.@@@...|
      |..@....|
      |..####.|
      +-------+

      Jet of gas pushes rock right:
      |...@...|
      |..@@@..|
      |...@...|
      |..####.|
      +-------+

      Rock falls 1 unit, causing it to come to rest:
      |...#...|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      A new rock begins falling:
      |....@..|
      |....@..|
      |..@@@..|
      |.......|
      |.......|
      |.......|
      |...#...|
      |..###..|
      |...#...|
      |..####.|
      +-------+

  The moment each of the next few rocks begins falling, you would see
  this:

      |..@....|
      |..@....|
      |..@....|
      |..@....|
      |.......|
      |.......|
      |.......|
      |..#....|
      |..#....|
      |####...|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      |..@@...|
      |..@@...|
      |.......|
      |.......|
      |.......|
      |....#..|
      |..#.#..|
      |..#.#..|
      |#####..|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      |..@@@@.|
      |.......|
      |.......|
      |.......|
      |....##.|
      |....##.|
      |....#..|
      |..#.#..|
      |..#.#..|
      |#####..|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      |...@...|
      |..@@@..|
      |...@...|
      |.......|
      |.......|
      |.......|
      |.####..|
      |....##.|
      |....##.|
      |....#..|
      |..#.#..|
      |..#.#..|
      |#####..|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      |....@..|
      |....@..|
      |..@@@..|
      |.......|
      |.......|
      |.......|
      |..#....|
      |.###...|
      |..#....|
      |.####..|
      |....##.|
      |....##.|
      |....#..|
      |..#.#..|
      |..#.#..|
      |#####..|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      |..@....|
      |..@....|
      |..@....|
      |..@....|
      |.......|
      |.......|
      |.......|
      |.....#.|
      |.....#.|
      |..####.|
      |.###...|
      |..#....|
      |.####..|
      |....##.|
      |....##.|
      |....#..|
      |..#.#..|
      |..#.#..|
      |#####..|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      |..@@...|
      |..@@...|
      |.......|
      |.......|
      |.......|
      |....#..|
      |....#..|
      |....##.|
      |....##.|
      |..####.|
      |.###...|
      |..#....|
      |.####..|
      |....##.|
      |....##.|
      |....#..|
      |..#.#..|
      |..#.#..|
      |#####..|
      |..###..|
      |...#...|
      |..####.|
      +-------+

      |..@@@@.|
      |.......|
      |.......|
      |.......|
      |....#..|
      |....#..|
      |....##.|
      |##..##.|
      |######.|
      |.###...|
      |..#....|
      |.####..|
      |....##.|
      |....##.|
      |....#..|
      |..#.#..|
      |..#.#..|
      |#####..|
      |..###..|
      |...#...|
      |..####.|
      +-------+

  To prove to the elephants your simulation is accurate, they want to know
  how tall the tower will get after 2022 rocks have stopped (but before
  the 2023rd rock begins falling). In this example, the tower of rocks
  will be *`3068`* units tall.

  *How many units tall will the tower of rocks be after 2022 rocks have
  stopped falling?*

  """
  def solve_1(data) do
    drop_rocks(data, 2022)
  end

  @doc """
  # Part 2

  The elephants are not impressed by your simulation. They demand to know
  how tall the tower will be after *`1000000000000`* rocks have stopped!
  Only then will they feel confident enough to proceed through the cave.

  In the example above, the tower would be *`1514285714288`* units tall!

  *How tall will the tower be after `1_000_000_000_000` rocks have stopped?*
  """
  def solve_2(data) do
    drop_rocks(data, 1_000_000_000_000)
  end

  # --- </Solution Functions> ---

  def rocks() do
    [
      # hline
      #   ####
      Rock.new(:hline, Enum.map(0..3, &{&1, 0})),

      # cross
      #   .#.
      #   ###
      #   .#.
      Rock.new(
        :cross,
        [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}]
      ),

      # leg
      #   ..#
      #   ..#
      #   ###
      Rock.new(
        :leg,
        [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}]
      ),

      # vline
      #   #
      #   #
      #   #
      #   #
      Rock.new(
        :vline,
        Enum.map(0..3, &{0, &1})
      ),

      # square
      #   ##
      #   ##
      Rock.new(
        :square,
        [{0, 0}, {1, 0}, {0, 1}, {1, 1}]
      )
    ]
  end

  def drop_rocks(wind, number) do
    initial_acc = %{
      final_rock_count: number,
      total_rock_count: 0,
      total_height: 0,
      cycle_wind: wind,
      cycles_seen: %{},
      original_wind: wind,
      height_offset: 0,
      cave: MapSet.new()
    }

    rocks()
    |> Stream.cycle()
    |> Enum.reduce_while(
      initial_acc,
      fn
        _rock, %{final_rock_count: same, total_rock_count: same} = acc ->
          {:halt, acc.total_height + acc.height_offset}

        rock, %{total_rock_count: total_rock_count} = acc when total_rock_count < number ->
          rock = Rock.move(rock, {2, acc.total_height + 3})

          {:cont, add_rock(rock, acc)}
      end
    )
  end

  defp add_rock(rock, %{cycle_wind: [], original_wind: original_wind} = acc) do
    add_rock(rock, %{acc | cycle_wind: original_wind})
  end

  defp add_rock(rock, %{cycle_wind: [dir | cycle_wind]} = acc) do
    blown_rock = Rock.move(rock, dir)

    blown_rock =
      if Rock.blocked?(blown_rock, @cave_width, acc.cave) do
        rock
      else
        blown_rock
      end

    moved_rock = Rock.move(blown_rock, :down)

    if Rock.blocked?(moved_rock, @cave_width, acc.cave) do
      total_rock_count = acc.total_rock_count + 1
      total_height = max(acc.total_height, Rock.top(blown_rock))
      cave = MapSet.union(acc.cave, Rock.positions(blown_rock))
      sig = for x <- @cave_width, y <- 1..20, {x, total_height - y} in cave, do: {x, y}
      key = {blown_rock.name, elem(blown_rock.origin, 0), length(cycle_wind), sig}

      case acc.cycles_seen[key] do
        {last_rock_count, last_height} ->
          rocks_left = acc.final_rock_count - total_rock_count
          cycle_size = total_rock_count - last_rock_count
          cycle_height = total_height - last_height
          cycles_to_get_close = div(rocks_left, cycle_size)
          total_rock_count = total_rock_count + cycles_to_get_close * cycle_size
          height_offset = cycles_to_get_close * cycle_height

          %{
            acc
            | total_rock_count: total_rock_count,
              total_height: total_height,
              height_offset: height_offset,
              cycle_wind: cycle_wind,
              cycles_seen: %{},
              cave: cave
          }

        nil ->
          cycles_seen = Map.put(acc.cycles_seen, key, {total_rock_count, total_height})

          %{
            acc
            | total_rock_count: total_rock_count,
              total_height: total_height,
              cycle_wind: cycle_wind,
              cycles_seen: cycles_seen,
              cave: cave
          }
      end
    else
      add_rock(moved_rock, %{acc | cycle_wind: cycle_wind})
    end
  end

  def draw(cave, rock \\ nil) do
    if false do
      {top, cave} =
        if rock do
          {max(Rock.top(rock), 3 + Enum.max(Enum.map(cave, fn {_, y} -> y end))),
           MapSet.union(Rock.positions(rock), cave)}
        else
          {3 + Enum.max(Enum.map(cave, fn {_, y} -> y end)), cave}
        end

      for y <- top..0 do
        IO.puts([?|, Enum.map(@cave_width, &if({&1, y} in cave, do: ?#, else: ?.)), ?|])
      end

      IO.puts("+-------+\n")
    end

    cave
  end
end
