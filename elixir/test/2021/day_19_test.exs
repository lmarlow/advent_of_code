defmodule AdventOfCode.Y2021.Day19Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2119

  alias AdventOfCode.Y2021.Day19, as: Solution

  @sample_data ~S"""
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == nil
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
