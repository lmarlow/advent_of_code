defmodule AdventOfCode.Y2020.Day19Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2019

  alias AdventOfCode.Y2020.Day19, as: Solution

  test "Year 2020, Day 19, Part 1" do
    assert Solution.run_1() == 248
  end

  test "Year 2020, Day 19, Part 2" do
    assert Solution.run_2() == 381
  end
end
