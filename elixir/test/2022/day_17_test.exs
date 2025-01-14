defmodule AdventOfCode.Y2022.Day17Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2217

  alias AdventOfCode.Y2022.Day17, as: Solution

  @sample_data ~S"""
  >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 3068
    end

    test "input file" do
      assert Solution.run(1) == 3181
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 1_514_285_714_288
    end

    test "input file" do
      assert Solution.run(2) == 1_570_434_782_634
    end
  end
end
