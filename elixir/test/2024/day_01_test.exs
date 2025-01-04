defmodule AdventOfCode.Y2024.Day01Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2401

  alias AdventOfCode.Y2024.Day01, as: Solution

  @sample_data ~S"""
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 11
    end

    test "input file" do
      assert Solution.run(1) == 2_066_446
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 31
    end

    test "input file" do
      assert Solution.run(2) == 24_931_009
    end
  end
end
