defmodule AdventOfCode.Y2021.Day07Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2107

  alias AdventOfCode.Y2021.Day07, as: Solution

  @sample_data ~S"""
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 37
    end

    test "input file" do
      assert Solution.run(1) == 337_488
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
