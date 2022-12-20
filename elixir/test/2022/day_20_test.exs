defmodule AdventOfCode.Y2022.Day20Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2220

  alias AdventOfCode.Y2022.Day20, as: Solution

  @sample_data ~S"""
  1
  2
  -3
  3
  -2
  0
  4
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 3
    end

    test "input file" do
      assert Solution.run(1) == 14888
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 1_623_178_306
    end

    test "input file" do
      assert Solution.run(2) == 3_760_092_545_849
    end
  end

  describe "decrypt" do
    test "example" do
      expected = [1, 2, -3, 4, 0, 3, -2]

      data =
        @sample_data
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)

      assert Enum.map(Solution.decrypt(data), &elem(&1, 0)) == expected
    end
  end
end
