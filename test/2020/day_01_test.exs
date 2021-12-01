defmodule AdventOfCode.Y2020.Day01Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2001

  alias AdventOfCode.Y2020.Day01, as: Solution

  describe "part 1" do
    test "sample" do
      data = ~S"""
      1721
      979
      366
      299
      675
      1456
      """

      assert Solution.run_1(data) == 514_579
    end

    test "input file" do
      assert Solution.run_1() == 1_015_476
    end
  end

  describe "part 2" do
    test "sample" do
      data = ~S"""
      1721
      979
      366
      299
      675
      1456
      """

      assert Solution.run_2(data) == 241_861_950
    end

    test "input file" do
      assert Solution.run_2() == 200_878_544
    end
  end
end
