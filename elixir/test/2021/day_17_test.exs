defmodule AdventOfCode.Y2021.Day17Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2117

  alias AdventOfCode.Y2021.Day17, as: Solution

  @sample_data ~S"""
  target area: x=20..30, y=-10..-5
  """

  describe "parse/1" do
    test "example" do
      assert Solution.parse(@sample_data) == {20..30, -10..-5}
    end
  end

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 45
    end

    test "input file" do
      assert Solution.run(1) == 33670
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 112
    end

    test "input file" do
      assert Solution.run(2) == 4903
    end
  end
end
