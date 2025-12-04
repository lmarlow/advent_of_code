defmodule AdventOfCode.Y2025.Day03Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2503

  alias AdventOfCode.Y2025.Day03, as: Solution

  @sample_data ~S"""
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  describe "part 1" do
    @describetag :y2503p1
    @tag :y2503p1ex
    test "example" do
      assert Solution.run(@sample_data, 1) == 357
    end

    @tag :y2503p1input
    test "input file" do
      assert Solution.run(1) == 17207
    end
  end

  describe "part 2" do
    @describetag :y2503p2
    @tag :y2503p2ex
    test "example" do
      assert Solution.run(@sample_data, 2) == nil
    end

    @tag :y2503p2input
    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
