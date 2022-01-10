defmodule AdventOfCode.Y2021.Day16Test do
  @moduledoc false

  use ExUnit.Case
  @moduletag :y2116

  alias AdventOfCode.Y2021.Day16, as: Solution

  describe "decoding" do
    test "b2tob16" do
      assert "38006F45291200" ==
               b2tob16("00111000000000000110111101000101001010010001001000000000")

      assert "EE00D40C823060" ==
               b2tob16("11101110000000001101010000001100100000100011000001100000")
    end

    test "type length id 0" do
      # 00111000000000000110111101000101001010010001001000000000
      packet = "38006F45291200" |> Solution.parse()

      assert %Solution{version: 1, type_id: 6, length_type_id: 0, sub_packets: sub_packets} =
               Solution.decode(packet)

      assert [%Solution{type_id: 4, value: 10}, %Solution{type_id: 4, value: 20}] = sub_packets
    end

    test "type length id 1" do
      # 11101110000000001101010000001100100000100011000001100000

      packet = "EE00D40C823060" |> Solution.parse()

      assert %Solution{version: 7, type_id: 3, length_type_id: 1, sub_packets: sub_packets} =
               Solution.decode(packet)

      assert [
               %Solution{type_id: 4, value: 1},
               %Solution{type_id: 4, value: 2},
               %Solution{type_id: 4, value: 3}
             ] = sub_packets
    end

    test "literals" do
      # # 110100101111111000101000
      # packet = "D2FE28" |> Solution.parse()
      # assert %Solution{version: 6, type_id: 4, value: 2021} = Solution.decode(packet)

      packet = "11010001010" |> decode2()
      assert %Solution{type_id: 4, value: 10} = Solution.decode(packet)

      packet = "0101001000100100" |> decode2()

      assert %Solution{type_id: 4, value: 20} = Solution.decode(packet)
    end
  end

  describe "part 1" do
    test "examples" do
      for {b16, version_sum} <- [
            {"8A004A801A8002F478", 16},
            {"620080001611562C8802118E34", 12},
            {"C0015000016115A2E0802F182340", 23},
            {"A0016C880162017C3686B18A3D4780", 31}
          ] do
        assert version_sum == Solution.run(b16, 1)
      end
    end

    test "input file" do
      assert Solution.run(1) == 871
    end
  end

  describe "part 2" do
    test "C200B40A82 finds the sum of 1 and 2, resulting in the value 3" do
      assert 3 == Solution.run("C200B40A82", 2)
    end

    test "04005AC33890 finds the product of 6 and 9, resulting in the value 54" do
      assert 54 == Solution.run("04005AC33890", 2)
    end

    test "880086C3E88112 finds the minimum of 7, 8, and 9, resulting in the value 7" do
      assert 7 == Solution.run("880086C3E88112", 2)
    end

    test "CE00C43D881120 finds the maximum of 7, 8, and 9, resulting in the value 9" do
      assert 9 == Solution.run("CE00C43D881120", 2)
    end

    test "D8005AC2A8F0 produces 1, because 5 is less than 15" do
      assert 1 == Solution.run("D8005AC2A8F0", 2)
    end

    test "F600BC2D8F produces 0, because 5 is not greater than 15" do
      assert 0 == Solution.run("F600BC2D8F", 2)
    end

    test "9C005AC2F8F0 produces 0, because 5 is not equal to 15" do
      assert 0 == Solution.run("9C005AC2F8F0", 2)
    end

    test "9C0141080250320F1802104A08 produces 1, because 1 + 3 = 2 * 2" do
      assert 1 == Solution.run("9C0141080250320F1802104A08", 2)
    end

    test "input file" do
      assert Solution.run(2) == 68_703_010_504
    end
  end

  def b2tob16(bits) do
    bits
    |> decode2()
    |> Base.encode16()
  end

  def decode2(bits) do
    bits
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&<<&1::1>>)
    |> Enum.into(<<>>)
  end
end
