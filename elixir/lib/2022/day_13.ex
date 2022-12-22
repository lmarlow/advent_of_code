defmodule AdventOfCode.Y2022.Day13 do
  @moduledoc """
  # Day 13: Distress Signal

  Problem Link: https://adventofcode.com/2022/day/13
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 13

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn code ->
      {list, _} = Code.eval_string(code)
      list
    end)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  You climb the hill and again try contacting the Elves. However, you
  instead receive a signal you weren't expecting: a *distress signal*.

  Your handheld device must still not be working properly; the packets
  from the distress signal got decoded *out of order*. You'll need to
  re-order the list of received packets (your puzzle input) to decode the
  message.

  Your list consists of pairs of packets; pairs are separated by a blank
  line. You need to identify *how many pairs of packets are in the right
  order*.

  For example:

      [1,1,3,1,1]
      [1,1,5,1,1]

      [[1],[2,3,4]]
      [[1],4]

      [9]
      [[8,7,6]]

      [[4,4],4,4]
      [[4,4],4,4,4]

      [7,7,7,7]
      [7,7,7]

      []
      [3]

      [[[]]]
      [[]]

      [1,[2,[3,[4,[5,6,7]]]],8,9]
      [1,[2,[3,[4,[5,6,0]]]],8,9]

  <span
  title="The snailfish called. They want their distress signal back.">Packet
  data consists of lists and integers.</span> Each list starts with `[`,
  ends with `]`, and contains zero or more comma-separated values (either
  integers or other lists). Each packet is always a list and appears on
  its own line.

  When comparing two values, the first value is called *left* and the
  second value is called *right*. Then:

  - If *both values are integers*, the *lower integer* should come first.
    If the left integer is lower than the right integer, the inputs are in
    the right order. If the left integer is higher than the right integer,
    the inputs are not in the right order. Otherwise, the inputs are the
    same integer; continue checking the next part of the input.
  - If *both values are lists*, compare the first value of each list, then
    the second value, and so on. If the left list runs out of items first,
    the inputs are in the right order. If the right list runs out of items
    first, the inputs are not in the right order. If the lists are the
    same length and no comparison makes a decision about the order,
    continue checking the next part of the input.
  - If *exactly one value is an integer*, convert the integer to a list
    which contains that integer as its only value, then retry the
    comparison. For example, if comparing `[0,0,0]` and `2`, convert the
    right value to `[2]` (a list containing `2`); the result is then found
    by instead comparing `[0,0,0]` and `[2]`.

  Using these rules, you can determine which of the pairs in the example
  are in the right order:

      == Pair 1 ==
      - Compare [1,1,3,1,1] vs [1,1,5,1,1]
        - Compare 1 vs 1
        - Compare 1 vs 1
        - Compare 3 vs 5
          - Left side is smaller, so inputs are in the right order

      == Pair 2 ==
      - Compare [[1],[2,3,4]] vs [[1],4]
        - Compare [1] vs [1]
          - Compare 1 vs 1
        - Compare [2,3,4] vs 4
          - Mixed types; convert right to [4] and retry comparison
          - Compare [2,3,4] vs [4]
            - Compare 2 vs 4
              - Left side is smaller, so inputs are in the right order

      == Pair 3 ==
      - Compare [9] vs [[8,7,6]]
        - Compare 9 vs [8,7,6]
          - Mixed types; convert left to [9] and retry comparison
          - Compare [9] vs [8,7,6]
            - Compare 9 vs 8
              - Right side is smaller, so inputs are not in the right order

      == Pair 4 ==
      - Compare [[4,4],4,4] vs [[4,4],4,4,4]
        - Compare [4,4] vs [4,4]
          - Compare 4 vs 4
          - Compare 4 vs 4
        - Compare 4 vs 4
        - Compare 4 vs 4
        - Left side ran out of items, so inputs are in the right order

      == Pair 5 ==
      - Compare [7,7,7,7] vs [7,7,7]
        - Compare 7 vs 7
        - Compare 7 vs 7
        - Compare 7 vs 7
        - Right side ran out of items, so inputs are not in the right order

      == Pair 6 ==
      - Compare [] vs [3]
        - Left side ran out of items, so inputs are in the right order

      == Pair 7 ==
      - Compare [[[]]] vs [[]]
        - Compare [[]] vs []
          - Right side ran out of items, so inputs are not in the right order

      == Pair 8 ==
      - Compare [1,[2,[3,[4,[5,6,7]]]],8,9] vs [1,[2,[3,[4,[5,6,0]]]],8,9]
        - Compare 1 vs 1
        - Compare [2,[3,[4,[5,6,7]]]] vs [2,[3,[4,[5,6,0]]]]
          - Compare 2 vs 2
          - Compare [3,[4,[5,6,7]]] vs [3,[4,[5,6,0]]]
            - Compare 3 vs 3
            - Compare [4,[5,6,7]] vs [4,[5,6,0]]
              - Compare 4 vs 4
              - Compare [5,6,7] vs [5,6,0]
                - Compare 5 vs 5
                - Compare 6 vs 6
                - Compare 7 vs 0
                  - Right side is smaller, so inputs are not in the right order

  What are the indices of the pairs that are already *in the right order*?
  (The first pair has index 1, the second pair has index 2, and so on.) In
  the above example, the pairs in the right order are 1, 2, 4, and 6; the
  sum of these indices is *`13`*.

  Determine which pairs of packets are already in the right order. *What
  is the sum of the indices of those pairs?*

  """
  def solve_1(data) do
    data
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.with_index(1)
    |> Enum.filter(&correct_order?/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @doc """
  # Part 2

  Now, you just need to put *all* of the packets in the right order.
  Disregard the blank lines in your list of received packets.

  The distress signal protocol also requires that you include two
  additional *divider packets*:

      [[2]]
      [[6]]

  Using the same rules as before, organize all packets - the ones in your
  list of received packets as well as the two divider packets - into the
  correct order.

  For the example above, the result of putting the packets in the correct
  order is:

      []
      [[]]
      [[[]]]
      [1,1,3,1,1]
      [1,1,5,1,1]
      [[1],[2,3,4]]
      [1,[2,[3,[4,[5,6,0]]]],8,9]
      [1,[2,[3,[4,[5,6,7]]]],8,9]
      [[1],4]
      [[2]]
      [3]
      [[4,4],4,4]
      [[4,4],4,4,4]
      [[6]]
      [7,7,7]
      [7,7,7,7]
      [[8,7,6]]
      [9]

  Afterward, locate the divider packets. To find the *decoder key* for
  this distress signal, you need to determine the indices of the two
  divider packets and multiply them together. (The first packet is at
  index 1, the second packet is at index 2, and so on.) In this example,
  the divider packets are *10th* and *14th*, and so the decoder key is
  *`140`*.

  Organize all of the packets into the correct order. *What is the decoder
  key for the distress signal?*

  """
  def solve_2(data) do
    [[[2]], [[6]] | data]
    |> Enum.sort(&correct_order?/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {packet, _index} -> packet in [[[2]], [[6]]] end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  # --- </Solution Functions> ---

  def correct_order?({{left, right}, _index}), do: correct_order?(left, right)

  @doc """
  - If *both values are integers*, the *lower integer* should come first.
    If the left integer is lower than the right integer, the inputs are in
    the right order. If the left integer is higher than the right integer,
    the inputs are not in the right order. Otherwise, the inputs are the
    same integer; continue checking the next part of the input.
  - If *both values are lists*, compare the first value of each list, then
    the second value, and so on. If the left list runs out of items first,
    the inputs are in the right order. If the right list runs out of items
    first, the inputs are not in the right order. If the lists are the
    same length and no comparison makes a decision about the order,
    continue checking the next part of the input.
  - If *exactly one value is an integer*, convert the integer to a list
    which contains that integer as its only value, then retry the
    comparison. For example, if comparing `[0,0,0]` and `2`, convert the
    right value to `[2]` (a list containing `2`); the result is then found
    by instead comparing `[0,0,0]` and `[2]`.
  """
  def correct_order?([], [_ | _]), do: true
  def correct_order?([_ | _], []), do: false
  def correct_order?([], []), do: :continue

  def correct_order?([int_same | rest_l], [int_same | rest_r]) when is_integer(int_same),
    do: correct_order?(rest_l, rest_r)

  def correct_order?([int_l | _rest_l], [int_r | _rest_r])
      when is_integer(int_l) and is_integer(int_r),
      do: int_l < int_r

  def correct_order?([int | rest], [list | _] = right)
      when is_integer(int) and is_list(list),
      do: correct_order?([[int] | rest], right)

  def correct_order?([list | _] = left, [int | rest])
      when is_integer(int) and is_list(list),
      do: correct_order?(left, [[int] | rest])

  def correct_order?([list_l | rest_l], [list_r | rest_r])
      when is_list(list_l) and is_list(list_r) do
    case correct_order?(list_l, list_r) do
      val when is_boolean(val) -> val
      _ -> correct_order?(rest_l, rest_r)
    end
  end
end
