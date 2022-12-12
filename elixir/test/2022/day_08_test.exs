defmodule AdventOfCode.Y2022.Day08Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2208

  alias AdventOfCode.Y2022.Day08, as: Solution

  @sample_data ~S"""
  30373
  25512
  65332
  33549
  35390
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 21
    end

    test "input file" do
      assert Solution.run(1) == 1803
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 8
    end

    test "input file" do
      assert Solution.run(2) == 268_912
    end
  end
end
