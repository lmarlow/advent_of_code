defmodule AdventOfCode.Y2022.Day16Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2216

  alias AdventOfCode.Y2022.Day16, as: Solution

  @sample_data ~S"""
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 1651
    end

    test "input file" do
      assert Solution.run(1) == nil
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
