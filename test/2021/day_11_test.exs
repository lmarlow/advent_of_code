defmodule AdventOfCode.Y2021.Day11Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2111

  alias AdventOfCode.Y2021.Day11, as: Solution

  @sample_data ~S"""
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 1656
    end

    test "input file" do
      assert Solution.run(1) == 1675
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 195
    end

    test "input file" do
      assert Solution.run(2) == 515
    end
  end
end
