defmodule AdventOfCode.Y2022.Day02Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2202

  alias AdventOfCode.Y2022.Day02, as: Solution

  @sample_data ~S"""
  A Y
  B X
  C Z
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 15
    end

    test "input file" do
      assert Solution.run(1) == 13809
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 12
    end

    test "input file" do
      assert Solution.run(2) == 12316
    end
  end
end
