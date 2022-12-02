defmodule AdventOfCode.Y2020.Day02Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2002

  alias AdventOfCode.Y2020.Day02, as: Solution

  describe "part 1" do
    test "example" do
      data = ~S"""
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """

      assert Solution.run(data, 1) == 2
    end

    test "input file" do
      assert Solution.run(1) == 506
    end
  end

  describe "part 2" do
    test "example" do
      data = ~S"""
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """

      assert Solution.run(data, 2) == 1
    end

    test "input file" do
      assert Solution.run(2) == 443
    end
  end
end
