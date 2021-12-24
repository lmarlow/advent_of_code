defmodule AdventOfCode.Y2021.Day12Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2112

  alias AdventOfCode.Y2021.Day12, as: Solution

  @sample_data ~S"""
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
  """

  describe "part 1" do
    test "simple 10" do
      data = """
      A-start
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
      """

      assert Solution.run(data, 1) == 10
    end

    test "simple 19" do
      data = """
      dc-end
      HN-start
      start-kj
      dc-start
      dc-HN
      LN-dc
      HN-end
      kj-sa
      kj-HN
      kj-dc
      """

      assert Solution.run(data, 1) == 19
    end

    test "example" do
      assert Solution.run(@sample_data, 1) == 226
    end

    test "input file" do
      assert Solution.run(1) == 4495
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
