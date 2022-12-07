defmodule AdventOfCode.Y2022.Day07Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2207

  alias AdventOfCode.Y2022.Day07, as: Solution

  @sample_data ~S"""
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 95437
    end

    test "input file" do
      assert Solution.run(1) == 1_315_285
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 24_933_642
    end

    test "input file" do
      assert Solution.run(2) == 9_847_279
    end
  end
end
