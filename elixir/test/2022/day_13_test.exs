defmodule AdventOfCode.Y2022.Day13Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2213

  alias AdventOfCode.Y2022.Day13, as: Solution

  @sample_data ~S"""
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 13
    end

    test "input file" do
      assert Solution.run(1) == 6101
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 140
    end

    test "input file" do
      assert Solution.run(2) == 21909
    end
  end
end
