defmodule AdventOfCode.Y2022.Day14Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2214

  alias AdventOfCode.Y2022.Day14, as: Solution

  @sample_data ~S"""
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 24
    end

    test "input file" do
      assert Solution.run(1) == 638
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 93
    end

    test "input file" do
      assert Solution.run(2) == 31722
    end
  end
end
