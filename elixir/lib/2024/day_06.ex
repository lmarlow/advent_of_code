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
    {map, position, velocity} = parse_map(data)

    map
    |> steps(position, velocity)
    |> then(fn {pos_vel_steps, _loop_detected} -> pos_vel_steps end)
    |> Enum.map(fn {pos, _vel} -> pos end)
    |> Enum.uniq()
    |> Enum.count()
  end

  @doc """
  # Part 2

  While The Historians begin working around the guard's patrol route, you
  borrow their fancy device and step outside the lab. From the safety of a
  supply closet, you time travel through the last few months and record the
  nightly status of the lab's guard post on the walls of the closet.

  Returning after what seems like only a few seconds to The Historians, they
  explain that the guard's patrol area is simply too large for them to safely
  search the lab without getting caught.

  Fortunately, they are pretty sure that adding a single new obstruction won't
  cause a time paradox. They'd like to place the new obstruction in such a way
  that the guard will get stuck in a loop, making the rest of the lab safe to
  search.

  To have the lowest chance of creating a time paradox, The Historians would
  like to know all of the possible positions for such an obstruction. The new
  obstruction can't be placed at the guard's starting position - the guard is
  there right now and would notice.

  In the above example, there are only 6 different positions where a new
  obstruction would cause the guard to get stuck in a loop. The diagrams of
  these six situations use O to mark the new obstruction, | to show a position
  where the guard moves up/down, - to show a position where the guard moves
  left/right, and + to show a position where the guard moves both up/down and
  left/right.

  Option one, put a printing press next to the guard's starting position:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ....|..#|.
  ....|...|.
  .#.O^---+.
  ........#.
  #.........
  ......#...

  Option two, put a stack of failed suit prototypes in the bottom right
  quadrant of the mapped area:


  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  ......O.#.
  #.........
  ......#...

  Option three, put a crate of chimney-squeeze prototype fabric next to the
  standing desk in the bottom right quadrant:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  .+----+O#.
  #+----+...
  ......#...

  Option four, put an alchemical retroencabulator near the bottom left corner:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  ..|...|.#.
  #O+---+...
  ......#...

  Option five, put the alchemical retroencabulator a bit to the right instead:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  ....|.|.#.
  #..O+-+...
  ......#...

  Option six, put a tank of sovereign glue right next to the tank of universal
  solvent:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  .+----++#.
  #+----++..
  ......#O..

  It doesn't really matter what you choose to use as an obstacle so long as you
  and The Historians can put it into position without the guard noticing. The
  important thing is having enough options that you can find one that minimizes
  time paradoxes, and in this example, there are 6 different positions you
  could choose.

  You need to get the guard stuck in a loop by adding a single new obstruction.
  How many different positions could you choose for this obstruction?
  """
  def solve_2(data) do
    {map, position, velocity} = parse_map(data)

    steps =
      map
      |> steps(position, velocity)
      |> then(fn {pos_vel_steps, _loop_detected} -> pos_vel_steps end)

    [_starting_position | possible_blocking_positions] =
      steps
      |> Enum.map(fn {pos, _vel} -> pos end)

    for {blocker_position, idx} <-
          Enum.uniq_by(Enum.with_index(possible_blocking_positions), fn {pos, _} -> pos end),
        new_map = Map.put(map, blocker_position, "O"),
        reduce: MapSet.new() do
      acc ->
        # skip ahead to just before the new blocker
        {pos, vel} = Enum.at(steps, idx - 1)

        with {_, true} <- steps(new_map, pos, vel) do
          MapSet.put(acc, blocker_position)
        else
          _ -> acc
        end
    end
    |> Enum.count()
  end

  # --- </Solution Functions> ---
  defp velocity("^"), do: {0, -1}
  defp velocity(">"), do: {1, 0}
  defp velocity("v"), do: {0, 1}
  defp velocity("<"), do: {-1, 0}

  # defp direction({0, -1}), do: "^"
  # defp direction({1, 0}), do: ">"
  # defp direction({0, 1}), do: "v"
  # defp direction({-1, 0}), do: "<"

  defp turn({0, -1}), do: {1, 0}
  defp turn({1, 0}), do: {0, 1}
  defp turn({0, 1}), do: {-1, 0}
  defp turn({-1, 0}), do: {0, -1}

  defp walk(map, {x, y} = position, {dx, dy} = velocity) do
    new_position = {x + dx, y + dy}

    case Map.get(map, new_position) do
      obstacle when obstacle in ["#", "O"] -> walk(map, position, turn(velocity))
      spot -> {new_position, velocity, spot}
    end
  end

  # defp map_to_string(map) do
  #   {xs, ys} = Enum.unzip(Map.keys(map))
  #   max_x = Enum.max(xs)
  #   max_y = Enum.max(ys)
  #
  #   for y <- 0..max_y, into: "" do
  #     line = for x <- 0..max_x, into: "", do: Map.get(map, {x, y}, ".")
  #
  #     line <> "\n"
  #   end
  # end

  defp parse_map(data) do
    map =
      for {line, y} <- Enum.with_index(data),
          {char, x} <- Enum.with_index(String.graphemes(line)),
          into: %{},
          do: {{x, y}, char}

    {start_position, direction} =
      Enum.find(map, fn {_position, direction} -> direction in ["^", ">", "v", "<"] end)

    {map, start_position, velocity(direction)}
  end

  defp steps(map, position, velocity) do
    {steps, _uniq_pos_vels, loop_detected} =
      {position, velocity}
      |> Stream.unfold(fn {position, velocity} ->
        with {new_position, new_velocity, <<_::binary>>} <- walk(map, position, velocity) do
          {{new_position, new_velocity}, {new_position, new_velocity}}
        else
          _other -> nil
        end
      end)
      |> Enum.reduce_while({[], MapSet.new(), false}, fn {_new_position, _new_velocity} = pos_vel,
                                                         {steps, unique_pos_vels, _loop_detected} ->
        if pos_vel in unique_pos_vels do
          {:halt, {steps, unique_pos_vels, true}}
        else
          {:cont, {[pos_vel | steps], MapSet.put(unique_pos_vels, pos_vel), false}}
        end
      end)

    {Enum.reverse(steps), loop_detected}
  end
end
