defmodule AdventOfCode.Y2021.Day14Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2114

  alias AdventOfCode.Y2021.Day14, as: Solution

  @sample_data ~S"""
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 1588
    end

    test "input file" do
      assert Solution.run(1) == 2549
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 2_188_189_693_529
    end

    test "input file" do
      assert Solution.run(2) == 2_516_901_104_210
    end
  end
end
