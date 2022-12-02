defmodule AdventOfCode.Y2021.Day05Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2105

  alias AdventOfCode.Y2021.Day05, as: Solution

  @sample_data ~S"""
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 5
    end

    test "input file" do
      assert Solution.run(1) == 7142
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 12
    end

    test "input file" do
      assert Solution.run(2) == 20012
    end
  end
end
