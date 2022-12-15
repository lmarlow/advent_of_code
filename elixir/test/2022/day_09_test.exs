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
      assert Solution.run(@sample_data, 2) == 1
    end

    test "tiny example" do
      sample = ~S"""
      R 4
      U 4
      """

      assert Solution.run(sample, 2) == 1
    end

    test "larger example" do
      sample = ~S"""
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
      """

      assert Solution.run(sample, 2) == 36
    end

    test "input file" do
      assert Solution.run(2) == 2331
    end
  end
end
