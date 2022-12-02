defmodule AdventOfCode.Y2021.Day09Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2109

  alias AdventOfCode.Y2021.Day09, as: Solution

  @sample_data ~S"""
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 15
    end

    test "input file" do
      assert Solution.run(1) == 462
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 1134
    end

    test "input file" do
      assert Solution.run(2) == 1_397_760
    end
  end
end
