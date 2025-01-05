defmodule AdventOfCode.Y2022.Day19 do
  @moduledoc """
  # Day 19: Not Enough Minerals

  Problem Link: https://adventofcode.com/2022/day/19
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 19

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  import NimbleParsec

  defparsec(:parse_blueprint, times(eventually(integer(min: 1, max: 2)), 7))

  @geode_index 0
  @obsidian_index 1
  @clay_index 2
  @ore_index 3

  defstruct blueprint: 0,
            minute: 0,
            minutes_left: 0,
            build_order: [],
            costs: %{
              ore: {0, 0, 0, 0},
              clay: {0, 0, 0, 0},
              obsidian: {0, 0, 0, 0},
              geode: {0, 0, 0, 0}
            },
            ores: {0, 0, 0, 0},
            robots: {0, 0, 0, 1},
            max_robots: {0, 0, 0, 0}

  def new([bp, ore_ore, clay_ore, obsidan_ore, obsidian_clay, geode_ore, geode_obsidian]) do
    %__MODULE__{
      blueprint: bp,
      costs: %{
        ore: {0, 0, 0, ore_ore},
        clay: {0, 0, 0, clay_ore},
        obsidian: {0, 0, obsidian_clay, obsidan_ore},
        geode: {0, geode_obsidian, 0, geode_ore}
      },
      max_robots:
        {1000, geode_obsidian, obsidian_clay,
         Enum.max([geode_ore, obsidan_ore, clay_ore, ore_ore])}
    }
  end

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_blueprint/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&new/1)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  Your scans show that the lava did indeed form obsidian!

  The wind has changed direction enough to stop sending lava droplets
  toward you, so you and the elephants exit the cave. As you do, you
  notice a collection of
  <a href="https://en.wikipedia.org/wiki/Geode" target="_blank">geodes</a>
  around the pond. Perhaps you could use the obsidian to create some
  *geode-cracking robots* and break them open?

  To collect the obsidian from the bottom of the pond, you'll need
  waterproof *obsidian-collecting robots*. Fortunately, there is an
  abundant amount of clay nearby that you can use to make them waterproof.

  In order to harvest the clay, you'll need special-purpose
  *clay-collecting robots*. To make any type of robot, you'll need *ore*,
  which is also plentiful but in the opposite direction from the clay.

  Collecting ore requires *ore-collecting robots* with big drills.
  Fortunately, *you have exactly one ore-collecting robot* in your pack
  that you can use to <span
  title="If You Give A Mouse An Ore-Collecting Robot">kickstart</span> the
  whole operation.

  Each robot can collect 1 of its resource type per minute. It also takes
  one minute for the robot factory (also conveniently from your pack) to
  construct any type of robot, although it consumes the necessary
  resources available when construction begins.

  The robot factory has many *blueprints* (your puzzle input) you can
  choose from, but once you've configured it with a blueprint, you can't
  change it. You'll need to work out which blueprint is best.

  For example:

      Blueprint 1:
        Each ore robot costs 4 ore.
        Each clay robot costs 2 ore.
        Each obsidian robot costs 3 ore and 14 clay.
        Each geode robot costs 2 ore and 7 obsidian.

      Blueprint 2:
        Each ore robot costs 2 ore.
        Each clay robot costs 3 ore.
        Each obsidian robot costs 3 ore and 8 clay.
        Each geode robot costs 3 ore and 12 obsidian.

  (Blueprints have been line-wrapped here for legibility. The robot
  factory's actual assortment of blueprints are provided one blueprint per
  line.)

  The elephants are starting to look hungry, so you shouldn't take too
  long; you need to figure out which blueprint would maximize the number
  of opened geodes after *24 minutes* by figuring out which robots to
  build and when to build them.

  Using blueprint 1 in the example above, the largest number of geodes you
  could open in 24 minutes is *`9`*. One way to achieve that is:

      == Minute 1 ==
      1 ore-collecting robot collects 1 ore; you now have 1 ore.

      == Minute 2 ==
      1 ore-collecting robot collects 1 ore; you now have 2 ore.

      == Minute 3 ==
      Spend 2 ore to start building a clay-collecting robot.
      1 ore-collecting robot collects 1 ore; you now have 1 ore.
      The new clay-collecting robot is ready; you now have 1 of them.

      == Minute 4 ==
      1 ore-collecting robot collects 1 ore; you now have 2 ore.
      1 clay-collecting robot collects 1 clay; you now have 1 clay.

      == Minute 5 ==
      Spend 2 ore to start building a clay-collecting robot.
      1 ore-collecting robot collects 1 ore; you now have 1 ore.
      1 clay-collecting robot collects 1 clay; you now have 2 clay.
      The new clay-collecting robot is ready; you now have 2 of them.

      == Minute 6 ==
      1 ore-collecting robot collects 1 ore; you now have 2 ore.
      2 clay-collecting robots collect 2 clay; you now have 4 clay.

      == Minute 7 ==
      Spend 2 ore to start building a clay-collecting robot.
      1 ore-collecting robot collects 1 ore; you now have 1 ore.
      2 clay-collecting robots collect 2 clay; you now have 6 clay.
      The new clay-collecting robot is ready; you now have 3 of them.

      == Minute 8 ==
      1 ore-collecting robot collects 1 ore; you now have 2 ore.
      3 clay-collecting robots collect 3 clay; you now have 9 clay.

      == Minute 9 ==
      1 ore-collecting robot collects 1 ore; you now have 3 ore.
      3 clay-collecting robots collect 3 clay; you now have 12 clay.

      == Minute 10 ==
      1 ore-collecting robot collects 1 ore; you now have 4 ore.
      3 clay-collecting robots collect 3 clay; you now have 15 clay.

      == Minute 11 ==
      Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
      1 ore-collecting robot collects 1 ore; you now have 2 ore.
      3 clay-collecting robots collect 3 clay; you now have 4 clay.
      The new obsidian-collecting robot is ready; you now have 1 of them.

      == Minute 12 ==
      Spend 2 ore to start building a clay-collecting robot.
      1 ore-collecting robot collects 1 ore; you now have 1 ore.
      3 clay-collecting robots collect 3 clay; you now have 7 clay.
      1 obsidian-collecting robot collects 1 obsidian; you now have 1 obsidian.
      The new clay-collecting robot is ready; you now have 4 of them.

      == Minute 13 ==
      1 ore-collecting robot collects 1 ore; you now have 2 ore.
      4 clay-collecting robots collect 4 clay; you now have 11 clay.
      1 obsidian-collecting robot collects 1 obsidian; you now have 2 obsidian.

      == Minute 14 ==
      1 ore-collecting robot collects 1 ore; you now have 3 ore.
      4 clay-collecting robots collect 4 clay; you now have 15 clay.
      1 obsidian-collecting robot collects 1 obsidian; you now have 3 obsidian.

      == Minute 15 ==
      Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
      1 ore-collecting robot collects 1 ore; you now have 1 ore.
      4 clay-collecting robots collect 4 clay; you now have 5 clay.
      1 obsidian-collecting robot collects 1 obsidian; you now have 4 obsidian.
      The new obsidian-collecting robot is ready; you now have 2 of them.

      == Minute 16 ==
      1 ore-collecting robot collects 1 ore; you now have 2 ore.
      4 clay-collecting robots collect 4 clay; you now have 9 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 6 obsidian.

      == Minute 17 ==
      1 ore-collecting robot collects 1 ore; you now have 3 ore.
      4 clay-collecting robots collect 4 clay; you now have 13 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 8 obsidian.

      == Minute 18 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      1 ore-collecting robot collects 1 ore; you now have 2 ore.
      4 clay-collecting robots collect 4 clay; you now have 17 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 3 obsidian.
      The new geode-cracking robot is ready; you now have 1 of them.

      == Minute 19 ==
      1 ore-collecting robot collects 1 ore; you now have 3 ore.
      4 clay-collecting robots collect 4 clay; you now have 21 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 5 obsidian.
      1 geode-cracking robot cracks 1 geode; you now have 1 open geode.

      == Minute 20 ==
      1 ore-collecting robot collects 1 ore; you now have 4 ore.
      4 clay-collecting robots collect 4 clay; you now have 25 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 7 obsidian.
      1 geode-cracking robot cracks 1 geode; you now have 2 open geodes.

      == Minute 21 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      1 ore-collecting robot collects 1 ore; you now have 3 ore.
      4 clay-collecting robots collect 4 clay; you now have 29 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 2 obsidian.
      1 geode-cracking robot cracks 1 geode; you now have 3 open geodes.
      The new geode-cracking robot is ready; you now have 2 of them.

      == Minute 22 ==
      1 ore-collecting robot collects 1 ore; you now have 4 ore.
      4 clay-collecting robots collect 4 clay; you now have 33 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 4 obsidian.
      2 geode-cracking robots crack 2 geodes; you now have 5 open geodes.

      == Minute 23 ==
      1 ore-collecting robot collects 1 ore; you now have 5 ore.
      4 clay-collecting robots collect 4 clay; you now have 37 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 6 obsidian.
      2 geode-cracking robots crack 2 geodes; you now have 7 open geodes.

      == Minute 24 ==
      1 ore-collecting robot collects 1 ore; you now have 6 ore.
      4 clay-collecting robots collect 4 clay; you now have 41 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 8 obsidian.
      2 geode-cracking robots crack 2 geodes; you now have 9 open geodes.

  However, by using blueprint 2 in the example above, you could do even
  better: the largest number of geodes you could open in 24 minutes is
  *`12`*.

  Determine the *quality level* of each blueprint by *multiplying that
  blueprint's ID number* with the largest number of geodes that can be
  opened in 24 minutes using that blueprint. In this example, the first
  blueprint has ID 1 and can open 9 geodes, so its quality level is *`9`*.
  The second blueprint has ID 2 and can open 12 geodes, so its quality
  level is *`24`*. Finally, if you *add up the quality levels* of all of
  the blueprints in the list, you get *`33`*.

  Determine the quality level of each blueprint using the largest number
  of geodes it could produce in 24 minutes. *What do you get if you add up
  the quality level of all of the blueprints in your list?*

  """
  def solve_1(blueprints) do
    blueprints
    |> Task.async_stream(&maximize_geodes(&1, 24), timeout: :infinity)
    |> Enum.map(&elem(&1, 1))
    # |> IO.inspect()
    |> Enum.map(&quality_level/1)
    # |> IO.inspect(charlists: :as_lists)
    |> Enum.sum()
  end

  @doc """
  # Part 2

  While you were choosing the best blueprint, the elephants found some
  food on their own, so you're not in as much of a hurry; you figure you
  probably have *32 minutes* before the wind changes direction again and
  you'll need to get out of range of the erupting volcano.

  Unfortunately, one of the elephants *ate most of your blueprint list*!
  Now, only the first three blueprints in your list are intact.

  In 32 minutes, the largest number of geodes blueprint 1 (from the
  example above) can open is *`56`*. One way to achieve that is:

      == Minute 1 ==
      1 ore-collecting robot collects 1 ore; you now have 1 ore.

      == Minute 2 ==
      1 ore-collecting robot collects 1 ore; you now have 2 ore.

      == Minute 3 ==
      1 ore-collecting robot collects 1 ore; you now have 3 ore.

      == Minute 4 ==
      1 ore-collecting robot collects 1 ore; you now have 4 ore.

      == Minute 5 ==
      Spend 4 ore to start building an ore-collecting robot.
      1 ore-collecting robot collects 1 ore; you now have 1 ore.
      The new ore-collecting robot is ready; you now have 2 of them.

      == Minute 6 ==
      2 ore-collecting robots collect 2 ore; you now have 3 ore.

      == Minute 7 ==
      Spend 2 ore to start building a clay-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      The new clay-collecting robot is ready; you now have 1 of them.

      == Minute 8 ==
      Spend 2 ore to start building a clay-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      1 clay-collecting robot collects 1 clay; you now have 1 clay.
      The new clay-collecting robot is ready; you now have 2 of them.

      == Minute 9 ==
      Spend 2 ore to start building a clay-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      2 clay-collecting robots collect 2 clay; you now have 3 clay.
      The new clay-collecting robot is ready; you now have 3 of them.

      == Minute 10 ==
      Spend 2 ore to start building a clay-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      3 clay-collecting robots collect 3 clay; you now have 6 clay.
      The new clay-collecting robot is ready; you now have 4 of them.

      == Minute 11 ==
      Spend 2 ore to start building a clay-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      4 clay-collecting robots collect 4 clay; you now have 10 clay.
      The new clay-collecting robot is ready; you now have 5 of them.

      == Minute 12 ==
      Spend 2 ore to start building a clay-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      5 clay-collecting robots collect 5 clay; you now have 15 clay.
      The new clay-collecting robot is ready; you now have 6 of them.

      == Minute 13 ==
      Spend 2 ore to start building a clay-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      6 clay-collecting robots collect 6 clay; you now have 21 clay.
      The new clay-collecting robot is ready; you now have 7 of them.

      == Minute 14 ==
      Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 2 ore.
      7 clay-collecting robots collect 7 clay; you now have 14 clay.
      The new obsidian-collecting robot is ready; you now have 1 of them.

      == Minute 15 ==
      2 ore-collecting robots collect 2 ore; you now have 4 ore.
      7 clay-collecting robots collect 7 clay; you now have 21 clay.
      1 obsidian-collecting robot collects 1 obsidian; you now have 1 obsidian.

      == Minute 16 ==
      Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      7 clay-collecting robots collect 7 clay; you now have 14 clay.
      1 obsidian-collecting robot collects 1 obsidian; you now have 2 obsidian.
      The new obsidian-collecting robot is ready; you now have 2 of them.

      == Minute 17 ==
      Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 2 ore.
      7 clay-collecting robots collect 7 clay; you now have 7 clay.
      2 obsidian-collecting robots collect 2 obsidian; you now have 4 obsidian.
      The new obsidian-collecting robot is ready; you now have 3 of them.

      == Minute 18 ==
      2 ore-collecting robots collect 2 ore; you now have 4 ore.
      7 clay-collecting robots collect 7 clay; you now have 14 clay.
      3 obsidian-collecting robots collect 3 obsidian; you now have 7 obsidian.

      == Minute 19 ==
      Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      7 clay-collecting robots collect 7 clay; you now have 7 clay.
      3 obsidian-collecting robots collect 3 obsidian; you now have 10 obsidian.
      The new obsidian-collecting robot is ready; you now have 4 of them.

      == Minute 20 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 3 ore.
      7 clay-collecting robots collect 7 clay; you now have 14 clay.
      4 obsidian-collecting robots collect 4 obsidian; you now have 7 obsidian.
      The new geode-cracking robot is ready; you now have 1 of them.

      == Minute 21 ==
      Spend 3 ore and 14 clay to start building an obsidian-collecting robot.
      2 ore-collecting robots collect 2 ore; you now have 2 ore.
      7 clay-collecting robots collect 7 clay; you now have 7 clay.
      4 obsidian-collecting robots collect 4 obsidian; you now have 11 obsidian.
      1 geode-cracking robot cracks 1 geode; you now have 1 open geode.
      The new obsidian-collecting robot is ready; you now have 5 of them.

      == Minute 22 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 2 ore.
      7 clay-collecting robots collect 7 clay; you now have 14 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 9 obsidian.
      1 geode-cracking robot cracks 1 geode; you now have 2 open geodes.
      The new geode-cracking robot is ready; you now have 2 of them.

      == Minute 23 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 2 ore.
      7 clay-collecting robots collect 7 clay; you now have 21 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 7 obsidian.
      2 geode-cracking robots crack 2 geodes; you now have 4 open geodes.
      The new geode-cracking robot is ready; you now have 3 of them.

      == Minute 24 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 2 ore.
      7 clay-collecting robots collect 7 clay; you now have 28 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 5 obsidian.
      3 geode-cracking robots crack 3 geodes; you now have 7 open geodes.
      The new geode-cracking robot is ready; you now have 4 of them.

      == Minute 25 ==
      2 ore-collecting robots collect 2 ore; you now have 4 ore.
      7 clay-collecting robots collect 7 clay; you now have 35 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 10 obsidian.
      4 geode-cracking robots crack 4 geodes; you now have 11 open geodes.

      == Minute 26 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 4 ore.
      7 clay-collecting robots collect 7 clay; you now have 42 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 8 obsidian.
      4 geode-cracking robots crack 4 geodes; you now have 15 open geodes.
      The new geode-cracking robot is ready; you now have 5 of them.

      == Minute 27 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 4 ore.
      7 clay-collecting robots collect 7 clay; you now have 49 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 6 obsidian.
      5 geode-cracking robots crack 5 geodes; you now have 20 open geodes.
      The new geode-cracking robot is ready; you now have 6 of them.

      == Minute 28 ==
      2 ore-collecting robots collect 2 ore; you now have 6 ore.
      7 clay-collecting robots collect 7 clay; you now have 56 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 11 obsidian.
      6 geode-cracking robots crack 6 geodes; you now have 26 open geodes.

      == Minute 29 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 6 ore.
      7 clay-collecting robots collect 7 clay; you now have 63 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 9 obsidian.
      6 geode-cracking robots crack 6 geodes; you now have 32 open geodes.
      The new geode-cracking robot is ready; you now have 7 of them.

      == Minute 30 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 6 ore.
      7 clay-collecting robots collect 7 clay; you now have 70 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 7 obsidian.
      7 geode-cracking robots crack 7 geodes; you now have 39 open geodes.
      The new geode-cracking robot is ready; you now have 8 of them.

      == Minute 31 ==
      Spend 2 ore and 7 obsidian to start building a geode-cracking robot.
      2 ore-collecting robots collect 2 ore; you now have 6 ore.
      7 clay-collecting robots collect 7 clay; you now have 77 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 5 obsidian.
      8 geode-cracking robots crack 8 geodes; you now have 47 open geodes.
      The new geode-cracking robot is ready; you now have 9 of them.

      == Minute 32 ==
      2 ore-collecting robots collect 2 ore; you now have 8 ore.
      7 clay-collecting robots collect 7 clay; you now have 84 clay.
      5 obsidian-collecting robots collect 5 obsidian; you now have 10 obsidian.
      9 geode-cracking robots crack 9 geodes; you now have 56 open geodes.

  However, blueprint 2 from the example above is still better; using it,
  the largest number of geodes you could open in 32 minutes is *`62`*.

  You *no longer have enough blueprints to worry about quality levels*.
  Instead, for each of the first three blueprints, determine the largest
  number of geodes you could open; then, multiply these three values
  together.

  Don't worry about quality levels; instead, just determine the largest
  number of geodes you could open using each of the first three
  blueprints. *What do you get if you multiply these numbers together?*
  """
  def solve_2(blueprints) do
    blueprints
    |> Enum.take(3)
    |> Task.async_stream(&maximize_geodes(&1, 32), timeout: :infinity)
    |> Enum.map(&elem(&1, 1))
    # |> IO.inspect()
    |> Enum.map(&elem(&1.ores, 0))
    # |> IO.inspect()
    |> Enum.product()
  end

  # --- </Solution Functions> ---

  defguardp can_afford?(costs, ores)
            when is_tuple(costs) and is_tuple(ores) and tuple_size(costs) == 4 and
                   tuple_size(ores) == 4 and elem(costs, 1) <= elem(ores, 1) and
                   elem(costs, 2) <= elem(ores, 2) and
                   elem(costs, 3) <= elem(ores, 3)

  def quality_level(%__MODULE__{blueprint: id, ores: ores}),
    do: id * elem(ores, @geode_index)

  def maximize_geodes(%__MODULE__{} = bp, minutes_left),
    do: maximize_geodes(%{bp | minutes_left: minutes_left})

  def maximize_geodes(%{minutes_left: 0} = bp),
    do: bp

  def maximize_geodes(%__MODULE__{} = bp) do
    for robot_to_build <- robot_build_options(bp),
        robot_to_build_index = type_index(robot_to_build),
        robot_to_build_costs = bp.costs[robot_to_build],
        reduce: bp do
      %{ores: {best_geodes, _, _, _}} = best_bp ->
        bp
        |> turn(robot_to_build, robot_to_build_index, robot_to_build_costs)
        |> Stream.iterate(&turn(&1, robot_to_build, robot_to_build_index, robot_to_build_costs))
        |> Enum.find(fn
          %{minutes_left: 0} -> true
          %{robots: latest_robots} -> not (latest_robots == bp.robots)
        end)
        |> maximize_geodes()
        |> then(fn
          %{ores: {new_geodes, _, _, _}} = new_bp when new_geodes > best_geodes ->
            new_bp

          _ ->
            best_bp
        end)
    end
  end

  defguardp could_build?(costs, robots)
            when (elem(costs, 1) == 0 or elem(robots, 1) > 0) and
                   (elem(costs, 2) == 0 or elem(robots, 2) > 0) and
                   (elem(costs, 3) == 0 or elem(robots, 3) > 0)

  defguardp should_build?(robot_index, robots, max_robots)
            when robot_index == @geode_index or
                   elem(robots, robot_index) < elem(max_robots, robot_index)

  # defguardp enough_time?(robot_index, minutes_left)
  #           when (robot_index == @obsidian_index and minutes_left > 2) or
  #                  (robot_index == @clay_index and minutes_left > 3) or
  #                  minutes_left > 1

  defp turn(bp, robot_to_build, robot_to_build_index, robot_to_build_costs) do
    bp
    |> build(robot_to_build_index, robot_to_build_costs)
    |> collect(bp.robots)
    |> then(&%{&1 | minute: &1.minute + 1, minutes_left: &1.minutes_left - 1})
    |> record_build(robot_to_build, bp.robots)
  end

  def robot_build_options(%{
        minutes_left: _minutes_left,
        costs: costs,
        robots: robots,
        max_robots: max_robots
      }) do
    for robot <- ~w[geode obsidian clay ore]a,
        robot_index = type_index(robot),
        # enough_time?(robot_index, minutes_left),
        could_build?(costs[robot], robots),
        should_build?(robot_index, robots, max_robots) do
      robot
    end
  end

  defp build(%__MODULE__{ores: resources} = bp, robot_index, costs)
       when can_afford?(costs, resources) do
    {_geode_cost, obsidian_cost, clay_cost, ore_cost} = costs
    {geodes, obsidians, clays, ores} = resources

    %{
      bp
      | ores: {geodes, obsidians - obsidian_cost, clays - clay_cost, ores - ore_cost},
        robots: put_elem(bp.robots, robot_index, 1 + elem(bp.robots, robot_index))
    }
  end

  defp build(bp, _, _), do: bp

  defp collect(
         %__MODULE__{ores: {geodes, obsidians, clays, ores}} = bp,
         {geode_bots, obsidian_bots, clay_bots, ore_bots}
       ) do
    %{
      bp
      | ores: {geodes + geode_bots, obsidians + obsidian_bots, clays + clay_bots, ores + ore_bots}
    }
  end

  defp record_build(%{build_order: build_order, robots: same_robots} = bp, _robot, same_robots) do
    %{bp | build_order: [{bp.minute, :skip, bp.ores, bp.robots} | build_order]}
  end

  defp record_build(%{build_order: build_order} = bp, robot, _initial_robots) do
    %{bp | build_order: [{bp.minute, robot, bp.ores, bp.robots} | build_order]}
  end

  defp type_index(:geode), do: @geode_index
  defp type_index(:obsidian), do: @obsidian_index
  defp type_index(:clay), do: @clay_index
  defp type_index(:ore), do: @ore_index
end
