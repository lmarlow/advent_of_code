defmodule AdventOfCode.Y2025.Day05Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2505

  alias AdventOfCode.Y2025.Day05, as: Solution

  @sample_data ~S"""
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  """

  describe "part 1" do
    @describetag :y2505p1
    @tag :y2505p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 3
    end

    @tag :y2505p1input
    test "input file" do
      assert Solution.run(1) == 690
    end
  end

  describe "part 2" do
    @describetag :y2505p2
    @tag :y2505p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == 14
    end

    @tag :y2505p2input
    test "input file" do
      assert Solution.run(2) == 344_323_629_240_733
    end
  end
end
