defmodule AdventOfCode.Y2024.Day05Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2405

  alias AdventOfCode.Y2024.Day05, as: Solution

  @sample_data ~S"""
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 143
    end

    test "input file" do
      assert Solution.run(1) == 5391
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 123
    end

    test "input file" do
      assert Solution.run(2) == nil
    end
  end
end
