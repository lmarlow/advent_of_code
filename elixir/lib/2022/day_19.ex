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
            build_order: [],
            costs: %{
              ore: {0, 0, 0, 0},
              clay: {0, 0, 0, 0},
              obsidian: {0, 0, 0, 0},
              geode: {0, 0, 0, 0},
              skip: {0, 0, 0, 0}
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
        geode: {0, geode_obsidian, 0, geode_ore},
        skip: {0, 0, 0, 0}
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
    # |> IO.inspect()
    |> Enum.sum()
  end

  @doc """
  # Part 2
  """
  def solve_2(data) do
    {2, :not_implemented, data}
  end

  # --- </Solution Functions> ---

  def quality_level(%__MODULE__{blueprint: id, ores: ores}),
    do: id * elem(ores, @geode_index)

  def maximize_geodes(bp, _minutes_left = 0),
    do: %{bp | build_order: Enum.reverse(bp.build_order)}

  def maximize_geodes(%__MODULE__{} = bp, minutes_left) do
    for robot_to_build <- robot_build_options(bp, minutes_left), reduce: bp do
      %{ores: {max_geodes, _, _, _}} = acc ->
        bp
        |> then(&%{&1 | minute: &1.minute + 1})
        |> spend(robot_to_build)
        |> collect_ore(bp.robots)
        # |> then(
        #   &%{&1 | build_order: [{&1.minute, robot_to_build, &1.ores, &1.robots} | &1.build_order]}
        # )
        |> maximize_geodes(minutes_left - 1)
        |> then(fn
          %{ores: {new_geodes, _, _, _}} = new_bp when new_geodes > max_geodes -> new_bp
          _ -> acc
        end)
    end
  end

  defguardp can_afford?(costs, ores)
            when elem(costs, 0) <= elem(ores, 0) and
                   elem(costs, 1) <= elem(ores, 1) and
                   elem(costs, 2) <= elem(ores, 2) and
                   elem(costs, 3) <= elem(ores, 3)

  for {[robot | _] = robot_options, min_time_left} <-
        Enum.with_index([[:geode], [:obsidian], [:clay, :ore, :skip], [:ore, :skip]], 1) do
    type_index = min_time_left - 1

    def robot_build_options(
          %{
            costs: %{unquote(robot) => robot_cost} = costs,
            ores: ores,
            robots: robots,
            max_robots: max_robots
          },
          minutes_left
        )
        when can_afford?(robot_cost, ores) and
               minutes_left > unquote(min_time_left) and
               elem(robots, unquote(type_index)) < elem(max_robots, unquote(type_index)) do
      unquote(robot_options)
      |> Enum.filter(&can_afford?(costs[&1], ores))
    end
  end

  def robot_build_options(_, _), do: [:skip]

  # defguardp can_afford?({c1, c2, c3, c4}, {o1, o2, o3, o4})
  #           when c1 <= o1 and c2 <= o2 and c3 <= o3 and c4 <= o4

  defp spend(%__MODULE__{} = bp, :skip), do: bp

  defp spend(%__MODULE__{costs: robot_costs, ores: {geodes, obsidians, clays, ores}} = bp, robot) do
    type_index = type_index(robot)
    {_geode_cost, obsidian_cost, clay_cost, ore_cost} = robot_costs[robot]

    %{
      bp
      | ores: {geodes, obsidians - obsidian_cost, clays - clay_cost, ores - ore_cost},
        robots: put_elem(bp.robots, type_index, 1 + elem(bp.robots, type_index))
    }
  end

  defp collect_ore(
         %__MODULE__{ores: {geodes, obsidians, clays, ores}} = bp,
         {geode_bots, obsidian_bots, clay_bots, ore_bots}
       ) do
    %{
      bp
      | ores: {geodes + geode_bots, obsidians + obsidian_bots, clays + clay_bots, ores + ore_bots}
    }
  end

  defp type_index(:geode), do: @geode_index
  defp type_index(:obsidian), do: @obsidian_index
  defp type_index(:clay), do: @clay_index
  defp type_index(:ore), do: @ore_index

  # defp enough_time?(
  #       %__MODULE__{
  #         robot_costs: %{
  #           geode: %{ore: geo_ore_cost, obsidian: geo_obs_cost},
  #           obsidian: %{ore: obs_ore_cost, clay: obs_clay_cost}
  #           clay: %{ore: clay_ore_cost}
  #         },
  #         robots: %{geode: geode_bots, obsidian: obs_bots, clay: clay_bots},
  #         inventory: %{obsidian: obs, ore: ore, clay: clay}
  #       } = bp,
  #        build_counts,
  #        minutes_left
  #      ) do
  #   :ok
  # end
end
