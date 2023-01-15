defmodule AdventOfCode.Y2022.Day18Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2218

  alias AdventOfCode.Y2022.Day18, as: Solution

  @sample_data ~S"""
  2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 64
    end

    test "input file" do
      assert Solution.run(1) == 4474
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
