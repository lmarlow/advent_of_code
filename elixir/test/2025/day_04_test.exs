defmodule AdventOfCode.Y2025.Day04Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2504

  alias AdventOfCode.Y2025.Day04, as: Solution

  @sample_data ~S"""
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  """

  describe "part 1" do
    @describetag :y2504p1
    @tag :y2504p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 13
    end

    @tag :y2504p1input
    test "input file" do
      assert Solution.run(1) == 1578
    end
  end

  describe "part 2" do
    @describetag :y2504p2
    @tag :y2504p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2504p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
