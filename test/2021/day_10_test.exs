defmodule AdventOfCode.Y2021.Day10Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2110

  alias AdventOfCode.Y2021.Day10, as: Solution

  @sample_data ~S"""
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
  """

  describe "part 1" do
    test "simple good" do
      assert Solution.run("({})", 1) == 0
    end

    test "simple unfinished" do
      assert Solution.run("({}", 1) == 0
    end

    test "simple corrupt" do
      assert Solution.run("({[})", 1) == 1197
    end

    test "example" do
      data = ~S"""
      {([(<{}[<>[]}>{[]{[(<()>
      [[<[([]))<([[{}[[()]]]
      [{[{({}]{}}([{[{{{}}([]
      [<(<(<(<{}))><([]([]()
      <{([([[(<>()){}]>(<<{{
      """

      assert Solution.run(data, 1) == 26397
    end

    test "input file" do
      assert Solution.run(1) == 271_245
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
