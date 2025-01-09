defmodule AdventOfCode.Y2024.Day08Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2408

  alias AdventOfCode.Y2024.Day08, as: Solution

  @sample_data ~S"""
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 14
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
