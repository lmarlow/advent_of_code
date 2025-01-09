defmodule AdventOfCode.Y2024.Day07Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2407

  alias AdventOfCode.Y2024.Day07, as: Solution

  @sample_data ~S"""
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 3749
    end

    test "input file" do
      assert Solution.run(1) == nil
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
