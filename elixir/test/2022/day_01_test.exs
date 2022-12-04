defmodule AdventOfCode.Y2022.Day01Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2201

  alias AdventOfCode.Y2022.Day01, as: Solution

  @sample_data ~S"""
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 24000
    end

    test "input file" do
      assert Solution.run(1) == 71023
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 45000
    end

    test "input file" do
      assert Solution.run(2) == 206_289
    end
  end
end
