defmodule AdventOfCode.Y2021.Day03Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2103

  alias AdventOfCode.Y2021.Day03, as: Solution

  describe "part 1" do
    test "example" do
      data = ~S"""
      """

      assert Solution.run(data, 1) == nil
    end

    test "input file" do
      assert Solution.run(1) == nil
    end
  end

  describe "part 2" do
    test "example" do
      data = ~S"""
      """

      assert Solution.run(data, 2) == nil
    end

    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
