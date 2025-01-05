defmodule AdventOfCode.Y2024.Day02Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2402

  alias AdventOfCode.Y2024.Day02, as: Solution

  @sample_data ~S"""
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 2
    end

    test "input file" do
      assert Solution.run(1) == 591
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
