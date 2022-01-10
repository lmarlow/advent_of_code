defmodule AdventOfCode.Y2021.Day16 do
  @moduledoc """
  --- Day 16: Packet Decoder ---
  Problem Link: https://adventofcode.com/2021/day/16
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 16

  defstruct version: 0,
            type_id: 0,
            length_type_id: 0,
            length: 0,
            value: nil,
            sub_packets: []

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part), do: data |> parse() |> solve(part)

  def parse(data) when is_binary(data) do
    data
    |> Base.decode16!()
  end

  def parse(data) when is_bitstring(data),
    do: data

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  """
  def solve_1(data) do
    data
    |> decode()
    |> sum_versions(0)
  end

  @doc """
  """
  def solve_2(data) do
    data
    |> decode()
    |> evaluate()
  end

  def sum_versions(%{version: version, type_id: 4}, acc), do: acc + version

  def sum_versions(%{version: version, sub_packets: sub_packets}, acc) do
    sub_packets
    |> Enum.reduce(acc + version, fn packet, acc -> sum_versions(packet, acc) end)
  end

  def count_packets(%{type_id: 4}, acc), do: acc + 1

  def count_packets(%{sub_packets: sub_packets}, acc) do
    sub_packets
    |> Enum.reduce(acc + 1, fn packet, acc -> count_packets(packet, acc) end)
  end

  def evaluate(%{type_id: 0, sub_packets: sub_packets}) do
    sub_packets
    |> Enum.map(&evaluate/1)
    |> Enum.sum()
  end

  def evaluate(%{type_id: 1, sub_packets: sub_packets}),
    do:
      sub_packets
      |> Enum.map(&evaluate/1)
      |> Enum.product()

  def evaluate(%{type_id: 2, sub_packets: sub_packets}),
    do:
      sub_packets
      |> Enum.map(&evaluate/1)
      |> Enum.min()

  def evaluate(%{type_id: 3, sub_packets: sub_packets}),
    do:
      sub_packets
      |> Enum.map(&evaluate/1)
      |> Enum.max()

  def evaluate(%{type_id: 4, value: value}), do: value

  def evaluate(%{type_id: 5, sub_packets: [a, b]}),
    do: if(evaluate(a) > evaluate(b), do: 1, else: 0)

  def evaluate(%{type_id: 6, sub_packets: [a, b]}),
    do: if(evaluate(a) < evaluate(b), do: 1, else: 0)

  def evaluate(%{type_id: 7, sub_packets: [a, b]}),
    do: if(evaluate(a) == evaluate(b), do: 1, else: 0)

  def decode(bin) when is_bitstring(bin) do
    {_rest, packet} = decode_packet(bin)
    packet
  end

  def decode_packet(<<version::3, rest::bits>>) do
    decode_type(rest, struct(__MODULE__, version: version))
  end

  def decode_type(<<4::3, rest::bits>>, packet) do
    decode_literal(rest, 0, %{packet | type_id: 4})
  end

  def decode_type(<<type_id::3, rest::bits>>, packet) do
    decode_operator(rest, %{packet | type_id: type_id})
  end

  def decode_operator(
        <<0::1, bit_count::15, sub_packet_data::bits-size(bit_count), rest::bits>>,
        packet
      ) do
    {rest,
     %{
       packet
       | length_type_id: 0,
         length: bit_count,
         sub_packets: decode_operator_len(sub_packet_data, [])
     }}
  end

  def decode_operator(
        <<1::1, packet_count::11, rest::bits>>,
        packet
      ) do
    {leftover, sub_packets} = decode_packet_count(packet_count, rest, [])

    packet = %{
      packet
      | length_type_id: 1,
        length: packet_count,
        sub_packets: sub_packets
    }

    {leftover, packet}
  end

  def decode_operator_len(<<>>, packets), do: Enum.reverse(packets)

  def decode_operator_len(data, packets) do
    {rest, packet} = decode_packet(data)
    decode_operator_len(rest, [packet | packets])
  end

  def decode_packet_count(0, leftover, packets), do: {leftover, Enum.reverse(packets)}

  def decode_packet_count(packet_count, data, packets) do
    {rest, packet} = decode_packet(data)
    decode_packet_count(packet_count - 1, rest, [packet | packets])
  end

  import Bitwise

  def decode_literal(
        <<0::1, value::4, rest::bits>>,
        acc,
        packet
      ) do
    {rest, %{packet | value: (acc <<< 4) + value}}
  end

  def decode_literal(
        <<_::1, value::4, rest::bits>>,
        acc,
        packet
      ) do
    decode_literal(rest, (acc <<< 4) + value, packet)
  end

  def encode2(bits) when is_bitstring(bits),
    do: for(<<x::size(1) <- bits>>, into: "", do: "#{x}")

  def p2(bits, opts \\ []), do: tap(bits, &IO.inspect(encode2(&1), opts))
  # --- </Solution Functions> ---
end
