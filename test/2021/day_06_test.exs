defmodule AdventOfCode.Y2021.Day06Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2106

  alias AdventOfCode.Y2021.Day06, as: Solution

  @sample_data ~S"""
  3,4,3,1,2
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 5934
    end

    test "input file" do
      assert Solution.run(1) == 352_195
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 26_984_457_539
    end

    test "input file" do
      assert Solution.run(2) == 1_600_306_001_288
    end
  end
end
