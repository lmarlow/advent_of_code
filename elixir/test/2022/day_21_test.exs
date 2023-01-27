defmodule AdventOfCode.Y2022.Day21Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2221

  alias AdventOfCode.Y2022.Day21, as: Solution

  @sample_data ~S"""
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
  """

  describe "part 1" do
    test "example" do
      assert Solution.run(@sample_data, 1) == 152
    end

    test "input file" do
      assert Solution.run(1) == 22_382_838_633_806
    end
  end

  describe "part 2" do
    test "example" do
      assert Solution.run(@sample_data, 2) == 301
    end

    test "input file" do
      assert Solution.run(2) == 3_099_532_691_300
    end
  end
end
