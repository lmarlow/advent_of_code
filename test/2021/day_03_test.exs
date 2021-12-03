defmodule AdventOfCode.Y2021.Day03Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2103

  alias AdventOfCode.Y2021.Day03, as: Solution

  @sample_data ~S"""
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  """
  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 198
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
