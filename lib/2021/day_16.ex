defmodule AdventOfCode.Y2021.Day16 do
  @moduledoc """
  --- Day 16: Packet Decoder ---
  Problem Link: https://adventofcode.com/2021/day/16
  """
  use AdventOfCode.Helpers.InputReader, year: 2021, day: 16

  defstruct version: 0, type_id: 0, length_type_id: 0, length: 0, value: nil, leftover: <<>>

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

  def sum_versions(%{version: version, type_id: 4}, acc), do: acc + version

  def sum_versions(%{version: version, value: sub_packets}, acc) do
    sub_packets
    |> Enum.reduce(acc + version, fn packet, acc -> sum_versions(packet, acc) end)
  end

  @doc """
  """
  def solve_2(data) do
    {2, :not_implemented}
  end

  def decode(bin) when is_bitstring(bin) do
    decode(bin, struct(__MODULE__))
  end

  def decode(<<version::3, 4::3, rest::bits>>, packet) do
    decode_literal(rest, <<>>, 0, %{packet | version: version, type_id: 4})
  end

  def decode(
        <<version::3, type_id::3, 0::1, bit_count::15, sub_packet_data::bits-size(bit_count),
          rest::bits>>,
        packet
      ) do
    %{
      packet
      | version: version,
        type_id: type_id,
        length_type_id: 0,
        length: bit_count,
        value: decode_packets(sub_packet_data, []),
        leftover: rest
    }
  end

  def decode(
        <<version::3, type_id::3, 1::1, packet_count::11, rest::bits>>,
        packet
      ) do
    %{
      packet
      | version: version,
        type_id: type_id,
        length_type_id: 1,
        length: packet_count,
        value: decode_n_packets(rest, packet_count, [])
    }
  end

  def decode(rest, packet), do: %{packet | leftover: rest}

  def decode_packets(data, packets) do
    case decode(data) do
      %{leftover: <<>>} = packet ->
        Enum.reverse([packet | packets])

      %{leftover: rest} = packet ->
        decode_packets(rest, [packet | packets])
    end
  end

  def decode_n_packets(_data, 0, packets),
    do: Enum.reverse(packets)

  def decode_n_packets(data, packet_count, packets) do
    %{leftover: rest} = packet = decode(data)
    decode_n_packets(rest, packet_count - 1, [packet | packets])
  end

  def decode_literal(
        <<0::1, last_word::bits-size(4), rest::bits>>,
        literal_bits,
        bit_count,
        packet
      ) do
    %{
      packet
      | leftover: rest,
        value:
          literal_value(
            <<literal_bits::bits-size(bit_count), last_word::bits-size(4)>>,
            bit_count + 4
          )
    }
  end

  def decode_literal(
        <<1::1, word::bits-size(4), rest::bits>>,
        literal_bits,
        bit_count,
        packet
      ) do
    decode_literal(
      rest,
      <<literal_bits::bits-size(bit_count), word::bits-size(4)>>,
      bit_count + 4,
      packet
    )
  end

  defp literal_value(literal_bits, bit_count) do
    <<value::size(bit_count)>> = literal_bits
    value
  end

  def encode2(bits) when is_bitstring(bits),
    do: for(<<x::size(1) <- bits>>, into: "", do: "#{x}")

  def p2(bits, opts \\ []), do: tap(bits, &IO.inspect(encode2(&1), opts))
  # --- </Solution Functions> ---
end
