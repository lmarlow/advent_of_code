defmodule AdventOfCode.Y2025.Day08Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2508

  alias AdventOfCode.Y2025.Day08, as: Solution

  @sample_data ~S"""
  162,817,812
  57,618,57
  906,360,560
  592,479,940
  352,342,300
  466,668,158
  542,29,236
  431,825,988
  739,650,466
  52,470,668
  216,146,977
  819,987,18
  117,168,530
  805,96,715
  346,949,466
  970,615,88
  941,993,340
  862,61,35
  984,92,344
  425,690,689
  """

  describe "part 1" do
    @describetag :y2508p1
    @tag :y2508p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 40
    end

    @tag :y2508p1input
    test "input file" do
      assert Solution.run(1) == 352_584
    end
  end

  describe "part 2" do
    @describetag :y2508p2
    @tag :y2508p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2508p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
