defmodule AdventOfCode.Y2025.Day10Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2510

  alias AdventOfCode.Y2025.Day10, as: Solution

  @sample_data ~S"""
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
  """

  describe "part 1" do
    @describetag :y2510p1
    @tag :y2510p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 7
    end

    @tag :y2510p1exl1
    test "example line 1" do
      assert Solution.solve_1(["[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"]) == 2
    end

    @tag :y2510p1exl2
    test "example line 2" do
      assert Solution.solve_1(["[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}"]) ==
               3
    end

    @tag :y2510p1exl3
    test "example line 3" do
      assert Solution.solve_1([
               "[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}"
             ]) == 2
    end

    @tag :y2510p1input
    test "input file" do
      assert Solution.run(1) == 457
    end
  end

  describe "part 2" do
    @describetag :y2510p2
    @tag :y2510p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2510p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
