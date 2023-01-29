defmodule AdventOfCode.Y2022.Day25Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2225

  alias AdventOfCode.Y2022.Day25, as: Solution

  @sample_data ~S"""
  1=-0-2
  12111
  2=0=
  21
  2=01
  111
  20012
  112
  1=-1=
  1-12
  12
  1=
  122
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == "2=-1=0"
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
