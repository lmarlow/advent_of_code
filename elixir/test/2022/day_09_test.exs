defmodule AdventOfCode.Y2022.Day09Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2209

  alias AdventOfCode.Y2022.Day09, as: Solution

  @sample_data ~S"""
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 13
    end

    test "input file" do
      assert Solution.run(1) == 5779
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
