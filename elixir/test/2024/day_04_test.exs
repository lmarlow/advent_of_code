defmodule AdventOfCode.Y2024.Day04Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2404

  alias AdventOfCode.Y2024.Day04, as: Solution

  @sample_data ~S"""
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 18
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
