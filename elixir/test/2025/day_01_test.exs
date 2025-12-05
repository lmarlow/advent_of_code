defmodule AdventOfCode.Y2025.Day01Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2501

  alias AdventOfCode.Y2025.Day01, as: Solution

  @sample_data ~S"""
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  describe "part 1" do
    @describetag :y2501p1
    @tag :y2501p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 3
    end

    @tag :y2501p1input
    test "input file" do
      assert Solution.run(1) == 1141
    end
  end

  describe "part 2" do
    @describetag :y2501p2
    @tag :y2501p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == 6
    end

    @tag :y2501p2input
    test "input file" do
      assert Solution.run(2) == 6634
    end
  end
end
