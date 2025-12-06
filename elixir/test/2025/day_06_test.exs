defmodule AdventOfCode.Y2025.Day06Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2506

  alias AdventOfCode.Y2025.Day06, as: Solution

  @sample_data ~S"""
  123 328  51 64 
  45 64  387 23 
  6 98  215 314
  *   +   *   +
  """

  describe "part 1" do
    @describetag :y2506p1
    @tag :y2506p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 4_277_556
    end

    @tag :y2506p1input
    test "input file" do
      assert Solution.run(1) == 7_644_505_810_277
    end
  end

  describe "part 2" do
    @describetag :y2506p2
    @tag :y2506p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2506p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
