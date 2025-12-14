defmodule AdventOfCode.Y2025.Day12Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2512

  alias AdventOfCode.Y2025.Day12, as: Solution

  @sample_data ~S"""
  0:
  ###
  ##.
  ##.

  1:
  ###
  ##.
  .##

  2:
  .##
  ###
  ##.

  3:
  ##.
  ###
  ##.

  4:
  ###
  #..
  ###

  5:
  ###
  .#.
  ###

  4x4: 0 0 0 0 2 0
  12x5: 1 0 1 0 2 2
  12x5: 1 0 1 0 3 2
  """

  describe "part 1" do
    @describetag :y2512p1
    @tag :y2512p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == nil
    end

    @tag :y2512p1input
    test "input file" do
      assert Solution.run(1) == nil
    end
  end

  describe "part 2" do
    @describetag :y2512p2
    @tag :y2512p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2512p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
