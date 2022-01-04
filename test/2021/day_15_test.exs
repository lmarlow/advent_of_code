defmodule AdventOfCode.Y2021.Day15Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2115

  alias AdventOfCode.Y2021.Day15, as: Solution

  @sample_data ~S"""
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  """

  describe "part 1" do
    test "tiny" do
      data = """
      119
      139
      211
      """

      assert Solution.run(data, 1) == 5
    end

    test "example" do
      assert Solution.run(@sample_data, 1) == 40
    end

    test "input file" do
      assert Solution.run(1) == 609
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 315
    end

    test "input file" do
      assert Solution.run(2) == 2925
    end
  end

  describe "expand_grid/2" do
    test "tiny" do
      data = """
      1
      """

      mini_grid = data |> Solution.parse() |> Solution.to_grid()
      assert %{{0, 0} => 1} = mini_grid
      expanded = Solution.expand_data(mini_grid, 2)
      assert %{{0, 0} => 1, {0, 1} => 2, {1, 0} => 2, {1, 1} => 3} = expanded
    end

    test "small" do
      data = """
      12
      38
      """

      mini_grid = data |> Solution.parse() |> Solution.to_grid()
      assert %{{1, 0} => 3} = mini_grid
      expanded = Solution.expand_data(mini_grid, 3)
      assert %{{1, 0} => 3, {0, 4} => 3, {0, 5} => 4, {3, 1} => 9, {3, 3} => 1} = expanded
    end
  end
end
