defmodule AdventOfCode.Y2021.Day01Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2101

  alias AdventOfCode.Y2021.Day01, as: Solution

  describe "part 1" do
    test "no data" do
      assert Solution.run_1([]) == 0
    end

    test "some increases" do
      assert Solution.run_1([1, 2, 1]) == 1
    end

    test "always decreasing" do
      assert Solution.run_1([3, 2, 1]) == 0
    end

    test "input file" do
      assert Solution.run_1() == 1298
    end
  end

  describe "part 2" do
    test "sample data" do
      assert Solution.run_2([607, 618, 618, 617, 647, 716, 769, 792]) == 5
    end

    test "input file" do
      assert Solution.run_2() == 1248
    end
  end
end
