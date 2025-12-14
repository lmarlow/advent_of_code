defmodule AdventOfCode.Y2025.Day11Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y25
  @moduletag :y2511

  alias AdventOfCode.Y2025.Day11, as: Solution

  @sample_data ~S"""
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
  """

  describe "part 1" do
    @describetag :y2511p1
    @tag :y2511p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == nil
    end

    @tag :y2511p1input
    test "input file" do
      assert Solution.run(1) == nil
    end
  end

  describe "part 2" do
    @describetag :y2511p2
    @tag :y2511p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2511p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
