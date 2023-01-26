defmodule AdventOfCode.Y2022.Day19Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2219

  alias AdventOfCode.Y2022.Day19, as: Solution

  @sample_data ~S"""
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 33
    end

    test "input file" do
      assert Solution.run(1) == 1766
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 3472
    end

    test "input file" do
      assert Solution.run(2) == 30780
    end
  end
end
