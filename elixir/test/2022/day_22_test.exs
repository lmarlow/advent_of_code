defmodule AdventOfCode.Y2022.Day22Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2222

  alias AdventOfCode.Y2022.Day22, as: Solution

  @sample_data ~S"""
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 6032
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
