defmodule AdventOfCode.Y2021.Day07Test do
  @moduledoc false

  use ExUnit.Case, async: true
  @moduletag :y2107

  alias AdventOfCode.Y2021.Day07, as: Solution

  @sample_data ~S"""
  16,1,2,0,4,2,7,1,2,14
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
      assert Solution.run(@sample_data, 2) == 168
    end

    test "input file" do
      assert Solution.run(2) == 89_647_695
    end
  end
end
