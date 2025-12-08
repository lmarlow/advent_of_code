defmodule AdventOfCode.Y2025.Day07Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2507

  alias AdventOfCode.Y2025.Day07, as: Solution

  @sample_data ~S"""
  .......S.......
  ...............
  .......^.......
  ...............
  ......^.^......
  ...............
  .....^.^.^.....
  ...............
  ....^.^...^....
  ...............
  ...^.^...^.^...
  ...............
  ..^...^.....^..
  ...............
  .^.^.^.^.^...^.
  ...............
  """

  describe "part 1" do
    @describetag :y2507p1
    @tag :y2507p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 21
    end

    @tag :y2507p1input
    test "input file" do
      assert Solution.run(1) == 1651
    end
  end

  describe "part 2" do
    @describetag :y2507p2
    @tag :y2507p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == 40
    end

    @tag :y2507p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
