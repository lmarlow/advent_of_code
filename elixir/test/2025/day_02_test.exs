defmodule AdventOfCode.Y2025.Day02Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2502

  alias AdventOfCode.Y2025.Day02, as: Solution

  @sample_data ~S"""
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 1_227_775_554
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
