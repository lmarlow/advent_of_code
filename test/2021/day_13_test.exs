defmodule AdventOfCode.Y2021.Day13Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2113

  alias AdventOfCode.Y2021.Day13, as: Solution

  @sample_data ~S"""
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 17
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
