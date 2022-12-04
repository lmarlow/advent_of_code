defmodule AdventOfCode.Y2022.Day03Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2203

  alias AdventOfCode.Y2022.Day03, as: Solution

  @sample_data ~S"""
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 157
    end

    test "input file" do
      assert Solution.run(1) == 7716
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 70
    end

    test "input file" do
      assert Solution.run(2) == 2973
    end
  end
end
