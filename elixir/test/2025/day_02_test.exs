defmodule AdventOfCode.Y2025.Day02Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2502

  alias AdventOfCode.Y2025.Day02, as: Solution

  @sample_data ~S"""
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 1_227_775_554
    end

    test "input file" do
      assert Solution.run(1) == 12_586_854_255
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
