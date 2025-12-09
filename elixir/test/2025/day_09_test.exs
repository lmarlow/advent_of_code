defmodule AdventOfCode.Y2025.Day09Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2509

  alias AdventOfCode.Y2025.Day09, as: Solution

  @sample_data ~S"""
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """

  describe "part 1" do
    @describetag :y2509p1
    @tag :y2509p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == nil
    end

    @tag :y2509p1input
    test "input file" do
      assert Solution.run(1) == nil
    end
  end

  describe "part 2" do
    @describetag :y2509p2
    @tag :y2509p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2509p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
