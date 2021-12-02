defmodule AdventOfCode.Y2021.Day02Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2102

  alias AdventOfCode.Y2021.Day02, as: Solution

  describe "part 1" do
    test "example" do
      data = ~S"""
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
      """

      assert Solution.run(data, 1) == 150
    end

    test "input file" do
      assert Solution.run(1) == 1_746_616
    end
  end

  describe "part 2" do
    test "example" do
      data = ~S"""
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
      """

      assert Solution.run(data, 2) == 900
    end

    test "input file" do
      assert Solution.run(2) == 1_741_971_043
    end
  end
end
