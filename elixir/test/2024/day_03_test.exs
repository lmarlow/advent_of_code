defmodule AdventOfCode.Y2024.Day03Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2403

  alias AdventOfCode.Y2024.Day03, as: Solution

  @sample_data ~S"""
  xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 161
    end

    test "input file" do
      assert Solution.run(1) == 187_833_789
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
