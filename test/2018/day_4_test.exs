defmodule AdventOfCode.Y2018.Day4Test do
  @moduledoc false
  use ExUnit.Case

  alias AdventOfCode.Y2018.Day4, as: Solution

  test "Year 2018, Day 4, Part 1" do
    assert Solution.run_1() == 74743
  end

  test "Year 2018, Day 4, Part 2" do
    assert Solution.run_2() == 132_484
  end
end
